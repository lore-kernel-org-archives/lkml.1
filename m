Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbXFQTeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbXFQTeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXFQTej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:34:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:6386 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXFQTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:34:38 -0400
Date: Sun, 17 Jun 2007 21:33:56 +0200
From: Carlo Wood <carlo@alinoe.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
Message-ID: <20070617193356.GB20727@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Adrian Bunk <bunk@stusta.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Oleg Verych <olecom@flower.upol.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org> <200706172118.19214.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706172118.19214.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 09:18:17PM +0200, Rafael J. Wysocki wrote:
> where n is a number that needs to be determined (I think that n could be 3).
> Well, "negative comments" should also be defined more precisely. ;-)

I think that n should be a function of the number of accepted patches
that this person sent in before, and the number of regressions he
caused in the past.

Ie, new developers have to wait a considerable amount of time - while
experienced developers who never caused a regression should be able
to write patches that are immediately applied. Also, if anyone causes
a regression - that would lead to them having to wait longer the
next time before they can apply the patch - a good reason for a
developer to put extra time into making sure there are no regressions.

-- 
Carlo Wood <carlo@alinoe.com>
