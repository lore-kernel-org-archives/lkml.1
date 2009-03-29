Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZC2WpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZC2WpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 18:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZC2Wo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 18:44:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZC2Wo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 18:44:56 -0400
Date: Sun, 29 Mar 2009 15:44:44 -0700 (PDT)
Message-Id: <20090329.154444.177112758.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       travis@sgi.com
Subject: Re: [PULL] cpumask updates for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903161444.41621.rusty@rustcorp.com.au>
References: <200903161444.41621.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 16 Mar 2009 14:44:41 +1030

>   ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-sparc.git master
> 
> Rusty Russell (10):
>       cpumask: Use smp_call_function_many(): sparc64
>       cpumask: arch_send_call_function_ipi_mask: sparc
>       cpumask: Use accessors code: sparc
>       cpumask: Use accessors code.: sparc64
>       cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc64
>       cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc
>       cpumask: remove cpu_coregroup_map: sparc
>       cpumask: remove the now-obsoleted pcibus_to_cpumask(): sparc
>       cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: sparc
>       cpumask: use mm_cpumask() wrapper: sparc

Pulled, thanks a lot Rusty.
