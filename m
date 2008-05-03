Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYECCpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYECCpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYECCpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:45:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbYECCpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:45:00 -0400
Date: Fri, 2 May 2008 22:44:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
cc: Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1209755665.25628.50.camel@dd.thebigcorporation.com>
Message-ID: <Pine.LNX.4.58.0805022244220.24994@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com> 
 <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
 <1209755665.25628.50.camel@dd.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> On Fri, 2008-05-02 at 15:02 -0400, Steven Rostedt wrote:
> > On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> > >
> > > On Fri, 2008-05-02 at 14:45 -0400, Steven Rostedt wrote:
> > > > On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> > >
> > > >
> > > > As for 2.6.25-rt1, I'm currently working on it. I have the patch queue
> > > > ready, but it has some major bugs that I'm stil working out. I did a bit
> > > > of clean up in the per-cpu portion as well as some of the mutex code. Now
> > > > I need to debug all those changes.
> > >
> > > Pls post what you have asap, we will all help you debug it.
> >
> > You'll have something today. I like to have a kernel that at least boots
> > ;-)
>
> Hey that's true for Linux always. Its more fun that way :)

I'm fixing quite a bit of paper bag bugs. I'm going to call it a night and
work more on it tomorrow night.

-- Steve
