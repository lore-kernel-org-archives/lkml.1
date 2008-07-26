Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbYGZLOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbYGZLOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 07:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYGZLOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 07:14:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbYGZLOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 07:14:37 -0400
Subject: Re: 2.6.24.7-rt15
From: Jaswinder Singh <jaswinder@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Sebastian Sewior <bigeasy@linutronix.de>,
       Greg Ungerer <gerg@snapgear.com>, Carsten Emde <ce@ceag.ch>
In-Reply-To: <1985e0f60807252248n581bdfa0s363f6ce0d283ec2c@mail.gmail.com>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	 <1985e0f60807252248n581bdfa0s363f6ce0d283ec2c@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 16:43:20 +0530
Message-Id: <1217070800.22147.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

> We are pleased to announce the 2.6.24.7-rt15 tree, which can be
> downloaded from the location:
> 
>  http://rt.et.redhat.com/download/
> 

linux-2.6/scripts/checkpatch.pl patch-2.6.24.7-rt15 is saying :

total: 479 errors, 813 warnings, 65464 lines checked

patch-2.6.24.7-rt15 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

It seems many of errors and warnings are quite simple and easily removable.

Thank you,

Jaswinder Singh.

