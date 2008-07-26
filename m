Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYGZM2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYGZM2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYGZM2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:28:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYGZM2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:28:44 -0400
Date: Sat, 26 Jul 2008 08:28:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh <jaswinder@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Sebastian Sewior <bigeasy@linutronix.de>,
       Greg Ungerer <gerg@snapgear.com>, Carsten Emde <ce@ceag.ch>
Subject: Re: 2.6.24.7-rt15
In-Reply-To: <1217070800.22147.8.camel@jaswinder.satnam>
Message-ID: <Pine.LNX.4.58.0807260827240.12591@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> 
 <1985e0f60807252248n581bdfa0s363f6ce0d283ec2c@mail.gmail.com>
 <1217070800.22147.8.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Jul 2008, Jaswinder Singh wrote:

> Hello all,
>
> > We are pleased to announce the 2.6.24.7-rt15 tree, which can be
> > downloaded from the location:
> >
> >  http://rt.et.redhat.com/download/
> >
>
> linux-2.6/scripts/checkpatch.pl patch-2.6.24.7-rt15 is saying :
>
> total: 479 errors, 813 warnings, 65464 lines checked
>
> patch-2.6.24.7-rt15 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
>
> It seems many of errors and warnings are quite simple and easily removable.

Yes, and they will be before going into mainilne.

Where's Daniel when you need him?

-- Steve

