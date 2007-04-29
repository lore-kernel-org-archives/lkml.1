Return-Path: <linux-kernel-owner+w=401wt.eu-S1161481AbXD2V4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161481AbXD2V4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161483AbXD2V4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:56:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38921 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161481AbXD2V4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:56:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Date: Mon, 30 Apr 2007 00:00:28 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426040806.GJ3468@stusta.de> <200704292218.11242.rjw@sisk.pl> <20070429204317.GR3468@stusta.de>
In-Reply-To: <20070429204317.GR3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704300000.29024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 22:43, Adrian Bunk wrote:
> On Sun, Apr 29, 2007 at 10:18:10PM +0200, Rafael J. Wysocki wrote:
> >...
> > But emailed reports _are_ saved anyway and we _know_ how to get a copy.
> > From lkml.org, for example.  Why don't we use that?  The only missing piece
> > is the 'keep a list' thing, but that's not a rocket science, IMHO.
> > 
> > [For example, you can create a bugzilla entry with a link to the lkml.org copy
> > of the relevant message, so why to require the reporter to file the report with
> > the bugzilla himself?]
> > 
> > _Moreover_, some LKML archives, for example at http://marc.info/?l=linux-kernel,
> > keep track of each thread separately, so you can browse any of them at any
> > time.  In particular, you can see the _history_ of each bug report sent to LKML
> > if you have a link to any message in its thread.
> > 
> > Really, if we ask reporters to put '[BUG]' in the subjects of their messages,
> > you'll even be able to use the lkml.org archives plus wget and a couple of
> > shell scripts to cherry pick the links to all bug reports sent to the list
> > within a given time interval.
> > 
> > All of this functionality is out there already.
> >...
> 
> How can I get the functionality "show me all unfixed SATA bugs"?
> 
> That's one of the important functionalities of every bug tracking 
> system.

That's the missing piece, obviously.

BTW, I didn't want to say that one could entirely replace a bug-tracking system
with tracking the LKML archives.  What I wanted to say was that the email
messages sent to the LKML were easily trackable and could be hooked up into a
bug-tracking system, for example with the help of URLs.

In such a setup people could send initial reports to the LKML and the links to
these messages might be put into a bug-tracking system as soon as it turned
out that the bugs were worthy of tracking.

Greetings,
Rafael
