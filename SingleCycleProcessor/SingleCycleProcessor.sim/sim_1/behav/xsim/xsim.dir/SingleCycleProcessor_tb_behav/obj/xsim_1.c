/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
IKI_DLLESPEC extern void execute_470(char*, char *);
IKI_DLLESPEC extern void execute_1151(char*, char *);
IKI_DLLESPEC extern void execute_3(char*, char *);
IKI_DLLESPEC extern void execute_638(char*, char *);
IKI_DLLESPEC extern void execute_801(char*, char *);
IKI_DLLESPEC extern void execute_1140(char*, char *);
IKI_DLLESPEC extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
IKI_DLLESPEC extern void execute_1142(char*, char *);
IKI_DLLESPEC extern void execute_1144(char*, char *);
IKI_DLLESPEC extern void execute_1145(char*, char *);
IKI_DLLESPEC extern void execute_1146(char*, char *);
IKI_DLLESPEC extern void execute_1147(char*, char *);
IKI_DLLESPEC extern void execute_1148(char*, char *);
IKI_DLLESPEC extern void execute_1149(char*, char *);
IKI_DLLESPEC extern void execute_1150(char*, char *);
IKI_DLLESPEC extern void execute_5(char*, char *);
IKI_DLLESPEC extern void execute_7(char*, char *);
IKI_DLLESPEC extern void execute_8(char*, char *);
IKI_DLLESPEC extern void execute_10(char*, char *);
IKI_DLLESPEC extern void execute_476(char*, char *);
IKI_DLLESPEC extern void execute_481(char*, char *);
IKI_DLLESPEC extern void execute_477(char*, char *);
IKI_DLLESPEC extern void execute_478(char*, char *);
IKI_DLLESPEC extern void execute_637(char*, char *);
IKI_DLLESPEC extern void execute_639(char*, char *);
IKI_DLLESPEC extern void execute_802(char*, char *);
IKI_DLLESPEC extern void execute_804(char*, char *);
IKI_DLLESPEC extern void execute_233(char*, char *);
IKI_DLLESPEC extern void execute_235(char*, char *);
IKI_DLLESPEC extern void execute_236(char*, char *);
IKI_DLLESPEC extern void execute_237(char*, char *);
IKI_DLLESPEC extern void execute_240(char*, char *);
IKI_DLLESPEC extern void execute_463(char*, char *);
IKI_DLLESPEC extern void execute_806(char*, char *);
IKI_DLLESPEC extern void execute_807(char*, char *);
IKI_DLLESPEC extern void execute_808(char*, char *);
IKI_DLLESPEC extern void execute_809(char*, char *);
IKI_DLLESPEC extern void execute_1135(char*, char *);
IKI_DLLESPEC extern void execute_1136(char*, char *);
IKI_DLLESPEC extern void execute_1137(char*, char *);
IKI_DLLESPEC extern void execute_1138(char*, char *);
IKI_DLLESPEC extern void execute_970(char*, char *);
IKI_DLLESPEC extern void execute_971(char*, char *);
IKI_DLLESPEC extern void execute_460(char*, char *);
IKI_DLLESPEC extern void execute_462(char*, char *);
IKI_DLLESPEC extern void execute_465(char*, char *);
IKI_DLLESPEC extern void execute_467(char*, char *);
IKI_DLLESPEC extern void execute_468(char*, char *);
IKI_DLLESPEC extern void execute_472(char*, char *);
IKI_DLLESPEC extern void execute_473(char*, char *);
IKI_DLLESPEC extern void execute_474(char*, char *);
IKI_DLLESPEC extern void execute_475(char*, char *);
IKI_DLLESPEC extern void execute_1152(char*, char *);
IKI_DLLESPEC extern void execute_1153(char*, char *);
IKI_DLLESPEC extern void execute_1154(char*, char *);
IKI_DLLESPEC extern void execute_1155(char*, char *);
IKI_DLLESPEC extern void execute_1156(char*, char *);
IKI_DLLESPEC extern void execute_1157(char*, char *);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
IKI_DLLESPEC extern void transaction_309(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void transaction_310(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void transaction_312(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void transaction_443(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[63] = {(funcp)execute_470, (funcp)execute_1151, (funcp)execute_3, (funcp)execute_638, (funcp)execute_801, (funcp)execute_1140, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_1142, (funcp)execute_1144, (funcp)execute_1145, (funcp)execute_1146, (funcp)execute_1147, (funcp)execute_1148, (funcp)execute_1149, (funcp)execute_1150, (funcp)execute_5, (funcp)execute_7, (funcp)execute_8, (funcp)execute_10, (funcp)execute_476, (funcp)execute_481, (funcp)execute_477, (funcp)execute_478, (funcp)execute_637, (funcp)execute_639, (funcp)execute_802, (funcp)execute_804, (funcp)execute_233, (funcp)execute_235, (funcp)execute_236, (funcp)execute_237, (funcp)execute_240, (funcp)execute_463, (funcp)execute_806, (funcp)execute_807, (funcp)execute_808, (funcp)execute_809, (funcp)execute_1135, (funcp)execute_1136, (funcp)execute_1137, (funcp)execute_1138, (funcp)execute_970, (funcp)execute_971, (funcp)execute_460, (funcp)execute_462, (funcp)execute_465, (funcp)execute_467, (funcp)execute_468, (funcp)execute_472, (funcp)execute_473, (funcp)execute_474, (funcp)execute_475, (funcp)execute_1152, (funcp)execute_1153, (funcp)execute_1154, (funcp)execute_1155, (funcp)execute_1156, (funcp)execute_1157, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_309, (funcp)transaction_310, (funcp)transaction_312, (funcp)transaction_443};
const int NumRelocateId= 63;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/SingleCycleProcessor_tb_behav/xsim.reloc",  (void **)funcTab, 63);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/SingleCycleProcessor_tb_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void wrapper_func_0(char *dp)

{

}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/SingleCycleProcessor_tb_behav/xsim.reloc");
	wrapper_func_0(dp);

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/SingleCycleProcessor_tb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/SingleCycleProcessor_tb_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/SingleCycleProcessor_tb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, (void*)0, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
