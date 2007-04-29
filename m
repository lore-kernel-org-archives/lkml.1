Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbXD2Sza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbXD2Sza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXD2Sza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:55:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbXD2Sz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:55:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 2.6.21
Date: Sun, 29 Apr 2007 20:59:47 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org>
In-Reply-To: <20070429180909.GA30604@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704292059.48563.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 20:09, Andi Kleen wrote:
> >  - a lot of reporters will not use bugzilla, because it's damn 
> >    inconvenient even for reporting. If you propose something that uses 
> 
> Don't think that's true. There are plenty of projects who only
> accept bugs through bugzilla (mozilla, various distributions, etc.) 
> and I don't see any evidence of your claim being true.
> 
> Sure there will be always people who cannot be bothered
> to use any kind of interface for bugs, but then
> these are unlikely to stay on board during a longer 
> remote debugging q'n'a session either. So those people
> can be just ignored; they essentially don't exist in
> the bug report universe.
> 
> Anyways it only works if people are willing to use it too and there
> are enough people who maintain bugs (aka ask questions to find out
> who to reassign, prune old bugs etc.)  If that's not there then
> it won't work well obviously, like it is currently the case.
> 
> I don't think the "keep it in Andrew's/Adrian's head" method
> is going to scale longer term at least (and one of them has 
> already thrown in the towel) 
> 
> The "send it to a gigantic mailing list and hope someone catches
> it" method also doesn't seem to be that great. At least there
> are lots of lost reports in my experience this way.

This, actually, might work if the report is 'flagged' in a specific way.

For example, if there's a message sent to LKML with a combination of '[BUG]'
and 'suspend' in the subject, I have no problems whatsoever with spotting it. ;-)

Greetings,
Rafael
