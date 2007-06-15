Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbXFOXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbXFOXVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXFOXVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:21:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756998AbXFOXVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:21:36 -0400
Date: Fri, 15 Jun 2007 16:20:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
In-Reply-To: <E1HyipW-0005wJ-0Q@flower>
Message-ID: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de>
 <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
 <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org>
 <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
 <E1HyipW-0005wJ-0Q@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Oleg Verych wrote:
> 
> I'm seeing this long (198) thread and just have no idea how it has
> ended (wiki? hand-mailing?).

I'm hoping it's not "ended".

IOW, I really don't think we _resolved_ anything, although the work that 
Adrian started is continuing through the wiki and other people trying to 
track regressions, and that was obviously something good.

But I don't think we really know where we want to take this thing in the 
long run. I think everybody wants a better bug-tracking system, but 
whether something that makes people satisfied can even be built is open. 
It sure doesn't seem to exist right now ;)

		Linus
