Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbZFJAEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbZFJAEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZFJAD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:03:59 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49437 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZFJAD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:03:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18990.61792.721530.554561@cargo.ozlabs.ibm.com>
Date: Wed, 10 Jun 2009 09:33:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
In-Reply-To: <20090609122529.GD25586@elte.hu>
References: <4A0B62F7.5030802@goop.org>
	<200906032208.28061.rusty@rustcorp.com.au>
	<alpine.LFD.2.01.0906030901460.4880@localhost.localdomain>
	<200906041554.37102.rusty@rustcorp.com.au>
	<alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
	<20090609093918.GC16940@wotan.suse.de>
	<20090609111719.GA4463@elte.hu>
	<20090609121055.GA9158@wotan.suse.de>
	<20090609122529.GD25586@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> I did this fork overhead measurement some time ago, using 
> perfcounters and 'perf':

Could you post the program?  I'd like to try it on some systems here.

Paul.
