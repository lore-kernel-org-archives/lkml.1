Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973Ab0ACR0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0ACR0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269Ab0ACR0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:26:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:36643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0ACR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:26:00 -0500
Date: Sun, 3 Jan 2010 09:26:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       saeed bishara <saeed.bishara@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Nicolas Pitre <nico@fluxnic.net>, Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>,
       Chris Dearman <chris@mips.com>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Coly Li <coly.li@suse.de>
Subject: Re: [PATCH] stack2core: show stack message and convert it to core 
 file when kernel die
Message-ID: <20100103092608.0a04c664@infradead.org>
In-Reply-To: <daef60381001030855o3a39c3fdr879e2634fb85c491@mail.gmail.com>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com>
	<20100103160313.GA21156@n2100.arm.linux.org.uk>
	<daef60381001030830u176c0cfavbb31358a2b42ed60@mail.gmail.com>
	<20100103164414.GB21156@n2100.arm.linux.org.uk>
	<daef60381001030855o3a39c3fdr879e2634fb85c491@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 00:55:04 +0800
Hui Zhu <teawater@gmail.com> wrote:
> 
> It show which line make kernel die.
> 

similar to scripts/markup_oops.pl already does ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
