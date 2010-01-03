Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029Ab0ACROO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab0ACROO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924Ab0ACROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:14:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36671 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0ACROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:14:12 -0500
Date: Sun, 3 Jan 2010 17:10:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hui Zhu <teawater@gmail.com>
Cc: saeed bishara <saeed.bishara@gmail.com>,
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
Message-ID: <20100103171013.GC21156@n2100.arm.linux.org.uk>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com> <20100103160313.GA21156@n2100.arm.linux.org.uk> <daef60381001030830u176c0cfavbb31358a2b42ed60@mail.gmail.com> <20100103164414.GB21156@n2100.arm.linux.org.uk> <daef60381001030855o3a39c3fdr879e2634fb85c491@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daef60381001030855o3a39c3fdr879e2634fb85c491@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 12:55:04AM +0800, Hui Zhu wrote:
> I didn't give the user raw oopses.
> I give him core file. When the kernel die, do we can get a core file now?

I think there's a communication issue here... clearly you're not
understanding what I've been trying to tell you.

I don't think I can help you any further.
