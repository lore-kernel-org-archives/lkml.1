Return-Path: <linux-kernel-owner+w=401wt.eu-S1161468AbXD2WAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161468AbXD2WAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161483AbXD2WAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:00:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32867 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161468AbXD2WAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:00:00 -0400
Date: Mon, 30 Apr 2007 00:00:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429220011.GV3468@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <200704292218.11242.rjw@sisk.pl> <20070429204317.GR3468@stusta.de> <200704300000.29024.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200704300000.29024.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:00:28AM +0200, Rafael J. Wysocki wrote:
> On Sunday, 29 April 2007 22:43, Adrian Bunk wrote:
> > On Sun, Apr 29, 2007 at 10:18:10PM +0200, Rafael J. Wysocki wrote:
> > >...
> > > But emailed reports _are_ saved anyway and we _know_ how to get a copy.
> > > From lkml.org, for example.  Why don't we use that?  The only missing piece
> > > is the 'keep a list' thing, but that's not a rocket science, IMHO.
> > > 
> > > [For example, you can create a bugzilla entry with a link to the lkml.org copy
> > > of the relevant message, so why to require the reporter to file the report with
> > > the bugzilla himself?]
> > > 
> > > _Moreover_, some LKML archives, for example at http://marc.info/?l=linux-kernel,
> > > keep track of each thread separately, so you can browse any of them at any
> > > time.  In particular, you can see the _history_ of each bug report sent to LKML
> > > if you have a link to any message in its thread.
> > > 
> > > Really, if we ask reporters to put '[BUG]' in the subjects of their messages,
> > > you'll even be able to use the lkml.org archives plus wget and a couple of
> > > shell scripts to cherry pick the links to all bug reports sent to the list
> > > within a given time interval.
> > > 
> > > All of this functionality is out there already.
> > >...
> > 
> > How can I get the functionality "show me all unfixed SATA bugs"?
> > 
> > That's one of the important functionalities of every bug tracking 
> > system.
> 
> That's the missing piece, obviously.
> 
> BTW, I didn't want to say that one could entirely replace a bug-tracking system
> with tracking the LKML archives.  What I wanted to say was that the email
> messages sent to the LKML were easily trackable and could be hooked up into a
> bug-tracking system, for example with the help of URLs.
> 
> In such a setup people could send initial reports to the LKML and the links to
> these messages might be put into a bug-tracking system as soon as it turned
> out that the bugs were worthy of tracking.

Who is doing this "might be put", and why don't you start with asking 
the submitter to submit bugs in a bug tracking system and forward the 
bug report from the bug tracking system (manually or automatically) to 
the developers and linux-kernel?

> Greetings,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

