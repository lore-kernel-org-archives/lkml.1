Return-Path: <linux-kernel-owner+w=401wt.eu-S966394AbXEHJph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966394AbXEHJph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934636AbXEHJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:45:35 -0400
Received: from www.osadl.org ([213.239.205.134]:56679 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934637AbXEHJpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:45:32 -0400
Subject: Re: [PATCH 2/5] x86_64: __setup_APIC_LVTT whitespace fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070508094339.GU3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <20070508094339.GU3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:48:19 +0200
Message-Id: <1178617700.3042.305.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:43 -0700, Chris Wright wrote:
> Completely trivial one.
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  arch/x86_64/kernel/apic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- tglx.orig/arch/x86_64/kernel/apic.c
> +++ tglx/arch/x86_64/kernel/apic.c
> @@ -779,7 +779,7 @@ void __init init_apic_mappings(void)
>  
>  #define APIC_DIVISOR 16
>  
> -static void __setup_APIC_LVTT(unsigned int clocks, int oneshot,int  irqen)
> +static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
>  {
>  	unsigned int lvtt_value, tmp_value;
>  

Thanks,

	tglx


