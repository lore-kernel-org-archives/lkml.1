Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbXFRFLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbXFRFLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXFRFKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:10:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbXFRFKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:10:51 -0400
Date: Sun, 17 Jun 2007 22:09:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
Message-Id: <20070617220927.99ebc1ee.akpm@linux-foundation.org>
In-Reply-To: <4675C083.6080409@s5r6.in-berlin.de>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	<200706172053.41806.bzolnier@gmail.com>
	<20070617115258.1f55b29d.akpm@linux-foundation.org>
	<200706172349.08813.bzolnier@gmail.com>
	<4675C083.6080409@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 01:15:15 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Tested-by

Tested-by would be good too.  Because over time, we will generate a list of
people who own the relevant hardware and who are prepared to test changes. 

So if you make changes to random-driver.c you can do `git-log
random-driver.c|grep Tested-by" to find people who can test your changes
for you.

Not that many people are likely to bother.  The consequences of being
slack are negligible, hence there is little incentive to do the extra
work.
