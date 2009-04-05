Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZDETJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZDETJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZDETJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:09:42 -0400
Received: from www.tglx.de ([62.245.132.106]:46489 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZDETJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:09:41 -0400
Date: Sun, 5 Apr 2009 21:09:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: System deadlock on 2.6.24-rt20 (-rt27 panics on
 locking-api-selftests)
In-Reply-To: <3efb10970904051200g4c725badp6d05092b70dd56a2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904052107500.747@localhost.localdomain>
References: <3efb10970904030502q1068731fl5b92f93d5341b43e@mail.gmail.com>  <alpine.LFD.2.00.0904051257470.747@localhost.localdomain>  <3efb10970904051139ue3802b1ib33487418188e4bc@mail.gmail.com>  <alpine.LFD.2.00.0904052046030.747@localhost.localdomain>
 <3efb10970904051200g4c725badp6d05092b70dd56a2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Apr 2009, Remy Bohmer wrote:
> > Seriously, I'm not going to look into that as my limited capacity is
> > focussed on 2.6.29-rt.
> 
> As it should be... :-)
> I was not asking you to fix it, my apologies if you read it that way.
> It is not that important to me, just a nice-to-have.

I did not interpret it that way :) I just wanted to explain instead of
just shrugging you off.

Thanks,

	tglx
