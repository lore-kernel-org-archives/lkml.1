Return-Path: <linux-kernel-owner+w=401wt.eu-S936973AbYEBTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936973AbYEBTP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbYEBTPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:15:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:60391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYEBTPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:15:00 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
	 <1209753250.25628.34.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
	 <1209754467.25628.42.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: The Big Corporation
Date: Fri, 02 May 2008 12:14:25 -0700
Message-Id: <1209755665.25628.50.camel@dd.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 15:02 -0400, Steven Rostedt wrote:
> On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> >
> > On Fri, 2008-05-02 at 14:45 -0400, Steven Rostedt wrote:
> > > On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> >
> > >
> > > As for 2.6.25-rt1, I'm currently working on it. I have the patch queue
> > > ready, but it has some major bugs that I'm stil working out. I did a bit
> > > of clean up in the per-cpu portion as well as some of the mutex code. Now
> > > I need to debug all those changes.
> >
> > Pls post what you have asap, we will all help you debug it.
> 
> You'll have something today. I like to have a kernel that at least boots
> ;-)

Hey that's true for Linux always. Its more fun that way :)

Lets definitely try and make it more bisectable:

I'll be pulling this into OpenSUSE 11 ASAP, so whatever I find I'll send
over!

Thanks !

Sven

