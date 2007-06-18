Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbXFRAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbXFRAdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXFRAdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:33:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52593 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbXFRAdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:33:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4675D296.40004@s5r6.in-berlin.de>
Date: Mon, 18 Jun 2007 02:32:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de> <200706180222.55282.bzolnier@gmail.com>
In-Reply-To: <200706180222.55282.bzolnier@gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> In case of being maintainer "bastard approach" is more about not discouraging
> developers by holding patches for too long than about getting credit.

The maintainer who is about to suffocate in newly contributed code is
actually a lucky guy:  He can ask his eager contributors to also help
with cross-reviewing and bug fixing, otherwise all the fine work will be
stuck in the clogged pipeline.  (E.g. post a subsystem todo-list now and
then, as a subtle hint.)
-- 
Stefan Richter
-=====-=-=== -==- =--=-
http://arcgraph.de/sr/
