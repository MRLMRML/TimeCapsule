package com.timecapsule.app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.timecapsule.app.domain.model.TimeCapsule
import com.timecapsule.app.domain.repository.TimeCapsuleRepository
import com.timecapsule.app.domain.usecase.CreateCapsuleUseCase
import com.timecapsule.app.domain.usecase.DeleteCapsuleUseCase
import com.timecapsule.app.domain.usecase.GetAllCapsulesUseCase
import com.timecapsule.app.domain.usecase.GetCapsuleByIdUseCase
import com.timecapsule.app.domain.usecase.OpenCapsuleUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.time.LocalDateTime

/**
 * UI State for the main screen.
 */
data class TimeCapsuleUiState(
    val capsules: List<TimeCapsule> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null,
    val selectedCapsule: TimeCapsule? = null,
    val isCreating: Boolean = false,
    val createdSuccessfully: Boolean = false
)

/**
 * ViewModel for managing Time Capsule UI state and operations.
 */
class TimeCapsuleViewModel(
    private val getAllCapsulesUseCase: GetAllCapsulesUseCase,
    private val getCapsuleByIdUseCase: GetCapsuleByIdUseCase,
    private val createCapsuleUseCase: CreateCapsuleUseCase,
    private val deleteCapsuleUseCase: DeleteCapsuleUseCase,
    private val openCapsuleUseCase: OpenCapsuleUseCase,
    private val repository: TimeCapsuleRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(TimeCapsuleUiState())
    val uiState: StateFlow<TimeCapsuleUiState> = _uiState.asStateFlow()

    init {
        loadCapsules()
    }

    private fun loadCapsules() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)
            try {
                getAllCapsulesUseCase().collect { capsules ->
                    _uiState.value = _uiState.value.copy(
                        capsules = capsules,
                        isLoading = false
                    )
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "Unknown error",
                    isLoading = false
                )
            }
        }
    }

    fun createCapsule(message: String, unlockTime: LocalDateTime) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isCreating = true)
            try {
                createCapsuleUseCase(message, unlockTime)
                _uiState.value = _uiState.value.copy(
                    isCreating = false,
                    createdSuccessfully = true
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "Failed to create capsule",
                    isCreating = false
                )
            }
        }
    }

    fun deleteCapsule(id: Long) {
        viewModelScope.launch {
            try {
                deleteCapsuleUseCase(id)
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "Failed to delete capsule"
                )
            }
        }
    }

    fun openCapsule(id: Long) {
        viewModelScope.launch {
            try {
                val capsule = openCapsuleUseCase(id)
                _uiState.value = _uiState.value.copy(selectedCapsule = capsule)
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "Failed to open capsule"
                )
            }
        }
    }

    fun loadCapsuleById(id: Long) {
        viewModelScope.launch {
            try {
                val capsule = getCapsuleByIdUseCase(id)
                _uiState.value = _uiState.value.copy(selectedCapsule = capsule)
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "Failed to load capsule"
                )
            }
        }
    }

    fun clearSelectedCapsule() {
        _uiState.value = _uiState.value.copy(selectedCapsule = null)
    }

    fun clearError() {
        _uiState.value = _uiState.value.copy(error = null)
    }

    fun clearCreatedFlag() {
        _uiState.value = _uiState.value.copy(createdSuccessfully = false)
    }

    class Factory(
        private val repository: TimeCapsuleRepository
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return TimeCapsuleViewModel(
                getAllCapsulesUseCase = GetAllCapsulesUseCase(repository),
                getCapsuleByIdUseCase = GetCapsuleByIdUseCase(repository),
                createCapsuleUseCase = CreateCapsuleUseCase(repository),
                deleteCapsuleUseCase = DeleteCapsuleUseCase(repository),
                openCapsuleUseCase = OpenCapsuleUseCase(repository),
                repository = repository
            ) as T
        }
    }
}
