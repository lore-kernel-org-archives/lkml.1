Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbXFQUBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbXFQUBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbXFQUBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:01:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48308 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbXFQUBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:01:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <467592D7.8050300@s5r6.in-berlin.de>
Date: Sun, 17 Jun 2007 22:00:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org> <200706172118.19214.rjw@sisk.pl> <20070617193356.GB20727@alinoe.com>
In-Reply-To: <20070617193356.GB20727@alinoe.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood wrote:
> On Sun, Jun 17, 2007 at 09:18:17PM +0200, Rafael J. Wysocki wrote:
>> where n is a number that needs to be determined (I think that n could be 3).
>> Well, "negative comments" should also be defined more precisely. ;-)
> 
> I think that n should be a function of the number of accepted patches
> that this person sent in before, and the number of regressions he
> caused in the past.

The character of the patch (potential impacts, size...) and availability
of reviewers and testers influence the required review time so much that
other factors, like reputation of the submitter, hardly matter.
-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/
