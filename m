Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZCLEUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZCLEUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZCLEUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:20:33 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35520 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751472AbZCLEUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:20:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JbVlRPqzsy6B0Mi1DW1Mv+wTnOR7QV2fTNcJh2fEDn99zPUoTAQt9geBgWRXX0nh1Psu1hxEzHFGzbvRgVoFXLzjOeW97+L2zH/+KDDRfZJvZsoPbs74To8aY5H9ZfwAwdtaCkm+nw/nEiP1z+B++i2WWgpdVicJdCdBCOdqr1o=  ;
X-YMail-OSG: IFXaF5kVM1khPjdJM7sxp9IyFFVWLRKg3BBEqxbFFq.PFrVQ8e14L6Gh2TMc26bVnmTSg_7ZjG9VCgZbC4kGGhEIGPoxtLlZ2oSZKuhn7lZIKb2nvj2gtTw3gjO09yCxSmpV05rfTtf447P16YcCRDzNddhiY40seyufr54av0lwdfTpytA57MBwhTkNtrUL5HCenbwDuabfAZl73rdd_1Gyw9UGHWys
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PULL] Wrapper macros for struct task_struct and struct mm_struct cpumask transition
Date: Thu, 12 Mar 2009 15:20:11 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200903121436.53055.rusty@rustcorp.com.au>
In-Reply-To: <200903121436.53055.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121520.12245.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 15:06:52 Rusty Russell wrote:
> The following changes since commit
> 99adcd9d67aaf04e28f5ae96df280f236bde4b66: Linus Torvalds (1):
>         Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq
>
> are available in the git repository at:
>
>  
> ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.
>git master
>
> Rusty Russell (2):
>       cpumask: tsk_cpumask for accessing the struct task_struct's
> cpus_allowed. cpumask: mm_cpumask for accessing the struct mm_struct's
> cpu_vm_mask.
>
>  include/linux/mm_types.h |    3 +++
>  include/linux/sched.h    |    3 +++

What's the transition?

