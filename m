Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbXFSA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbXFSA2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbXFSA2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:28:19 -0400
Received: from dvhart.com ([64.146.134.43]:45751 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbXFSA2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:28:18 -0400
Message-ID: <46772321.9080602@mbligh.org>
Date: Mon, 18 Jun 2007 17:28:17 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 14 Jun 2007, Oleg Verych wrote:
>> I'm seeing this long (198) thread and just have no idea how it has
>> ended (wiki? hand-mailing?).
> 
> I'm hoping it's not "ended".
> 
> IOW, I really don't think we _resolved_ anything, although the work that 
> Adrian started is continuing through the wiki and other people trying to 
> track regressions, and that was obviously something good.
> 
> But I don't think we really know where we want to take this thing in the 
> long run. I think everybody wants a better bug-tracking system, but 
> whether something that makes people satisfied can even be built is open. 
> It sure doesn't seem to exist right now ;)

I know you hate bugzilla ... but at least I can try to make that bit
of the process work better.

The new version just rolled out does have a simple "regression" checkbox
(and you can search on it), which will hopefully help people keep track
of the ones already in bugzilla more easily.

Thanks to Jon T, Dave J et al. for helping to figure out methods and
implement them.

M.
