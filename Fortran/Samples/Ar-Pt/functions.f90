module functions
    use parameters
    implicit none

contains
    LOGICAL function isInterface(kind, i)
        integer, intent(in) :: kind, i

        if (kind == topPt) then
            if (i <= N_LAYER*INTERFACE_LAYER) then
                isInterface = .TRUE.
            else 
                isInterface = .FALSE.
            end if
        else if (kind == botPt) then
            if (N_LAYER*(PHANTOM_LAYER+1)+1 <= i) then
                isInterface = .TRUE.
            else 
                isInterface = .FALSE.
            end if
        else
            isInterface = .FALSE.
        end if

    end function isInterface

    LOGICAL function isPhantom(kind, i)
        integer, intent(in) :: kind, i

        if (kind == topPt) then
            if (N_LAYER*INTERFACE_LAYER+1 <= i .and. i <= N_LAYER*(INTERFACE_LAYER+PHANTOM_LAYER)) then
                isPhantom = .TRUE.
            else 
                isPhantom = .FALSE.
            end if
        else if (kind == botPt) then
            if (N_LAYER+1 <= i .and. i <= N_LAYER*(PHANTOM_LAYER+1)) then
                isPhantom = .TRUE.
            else 
                isPhantom = .FALSE.
            end if
        else
            isPhantom = .FALSE.
        end if

    end function isPhantom

    LOGICAL function isNotFixed(kind, i)
        integer, intent(in) :: kind, i
        
        if (kind == topPt) then
            if (N_LAYER*(INTERFACE_LAYER+PHANTOM_LAYER)+1 <= i) then
                isNotFixed = .FALSE.
            else
                isNotFixed = .TRUE.
            end if
        else if (kind == botPt) then
            if (i <= N_LAYER) then
                isNotFixed = .FALSE.
            else 
                isNotFixed = .TRUE.
            end if
        else
            isNotFixed = .TRUE.
        end if

    end function isNotFixed

end module functions