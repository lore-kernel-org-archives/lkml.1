Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbXD2Qeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbXD2Qeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbXD2Qeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:34:50 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:52188 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbXD2Qet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:34:49 -0400
Message-ID: <4634C8F8.1060109@s5r6.in-berlin.de>
Date: Sun, 29 Apr 2007 18:34:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sun, 29 Apr 2007, Andi Kleen wrote:
>> - Ask more people to just categorize and reassign bugs (anybody interested?)
>> - Give more people in bugzilla the power to reassign arbitary bugs
>>   (bugzilla maintainers would need to do that)
> 
> I think both of these are good ideas, but I don't think it's enough. There 
> must be some better form of bug tracking than bugzilla. Some relly 
> distributed way of letting people work together, *without* having to 
> congregate on some central web-site kind of thing. A "git for bugs", where 
> you can track bugs locally and without a web interface.
> 
> And I think it would be something much closer to "distributed email mbox 
> with status tracking facilities", _not_ a web clicky interface.

It has to be able to suck in reports from people who don't know much
about how the Linux guys handle bugs, and has to keep the reporters
involved up until a bug can be closed.  IOW it has to be compatible with
integrators, developers, and reporters/testers.  Luckily though, not all
of them need all of that system's features.  ('system' == the right
people with the right tools)
-- 
Stefan Richter
-=====-=-=== -=-- ===-=
http://arcgraph.de/sr/
