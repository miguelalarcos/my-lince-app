export const validateItem = {
    desc: (val) => {
        if(/^\w+\s+\w+\s+\w+.*$/.test(val)){
            return ''
        }
        else{
            return 'Al menos tres palabras'
        }
    }
}