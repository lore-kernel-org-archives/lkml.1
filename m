Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbXJKWQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbXJKWQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXJKWOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:14:45 -0400
Received: from ozlabs.org ([203.10.76.45]:52676 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbXJKWOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:14:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18190.41037.770255.259749@cargo.ozlabs.ibm.com>
Date: Fri, 12 Oct 2007 08:14:37 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: markn@au1.ibm.com, PowerPC dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE #define
In-Reply-To: <2C31F1C3-3337-483B-A463-767459305F1E@kernel.crashing.org>
References: <20071011071558.676463639@au1.ibm.com>
	<20071011072208.075979098@au1.ibm.com>
	<DFC6881D-E917-4EC5-B19C-8CE04E040B06@kernel.crashing.org>
	<18190.39864.4562.852292@cargo.ozlabs.ibm.com>
	<2C31F1C3-3337-483B-A463-767459305F1E@kernel.crashing.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> > ELF_CORE_XFPREG_TYPE is a suitable name for something that's used in
> > conjunction with a function called elf_core_copy_task_xfpregs().
> 
> agreed, I think the function name should change as well.

Maybe.  Let's do one step at a time...

Paul.
