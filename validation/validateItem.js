export const validateItem = {
    desc: (val) => {
        if(/^\w+\s+\w+\s+\w+.*$/.test(val)){
            console.log('ok!')
            return ''
        }
        else{
            console.log('fail!')
            return 'Al menos tres palabras'
        }
    }
}