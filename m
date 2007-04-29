Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbXD2AVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbXD2AVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbXD2AVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:21:01 -0400
Received: from gherkin.frus.com ([192.158.254.49]:46657 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbXD2AVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:21:00 -0400
Subject: Re: Linux 2.6.21
In-Reply-To: <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
 "from Linus Torvalds at Apr 28, 2007 04:40:31 pm"
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Apr 2007 19:20:46 -0500 (CDT)
CC: Markus Rechberger <mrechberger@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070429002046.AC3EBDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sun, 29 Apr 2007, Markus Rechberger wrote:
> > How else should bugs get handled, sending them to the lkml?
> 
> Actually, looking at Adrian's regression lists, yes. lkml worked better 
> than bugzilla did. By at _least_ a factor of two.

Since 1992, lkml (with "Cc:" to the appropriate subsystem mailing list
if applicable) and the presumed responsible parties are the only channels
I've used to report the bugs I encounter.

Other methods come and go, but old habits die hard, particularly when
they have a knack for producing the desired result.  Historically,
requiring a developer to fire up a GUI to read a bug report decreases
the chance that bug report will be noticed.  The development community
can do whatever flips its collective switch as far as tracking bugs,
but the bugs have to be reported and noticed before tracking becomes a
meaningful activity.

One more thought and I'll get off your screens...  We've steadfastly
resisted making lkml and friends subscriber-only mailing lists precisely
because we don't want to miss a potential bug report because a would-be
submitter isn't subscribed.  If people aren't looking for bug reports
here, what's the point?

--Bob Tracy
rct@frus.com
