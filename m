Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYFAMG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYFAMG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 08:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYFAMGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 08:06:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYFAMGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 08:06:17 -0400
Date: Sun, 1 Jun 2008 08:06:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Engelhardt <jengelh@medozas.de>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt4
In-Reply-To: <alpine.LNX.1.10.0806010940040.4055@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0806010805410.21278@gandalf.stny.rr.com>
References: <1212076754.24785.18.camel@localhost.localdomain>
 <alpine.LNX.1.10.0806010940040.4055@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jun 2008, Jan Engelhardt wrote:

>
>
> On Thursday 2008-05-29 17:59, Steven Rostedt wrote:
>
> >We are pleased to announce the 2.6.25.4-rt4 tree,[...]
>
> I am getting tons of the following two stack traces (see below)
> during normal operation. 2.6.25.4-rt4, compiled for i586+SMP,
> running on i686+UP. syslogd even gets so far as to say "suppressed 134
> messages", so it's really a lot. I am tempted to just disable
> CONFIG_DEBUG_PREEMPT because otherwise it seems to work.

Yeah, this has been reported. I'll work on getting a -rt5 out on Monday
with more fixes.

Thanks,

-- Steve

