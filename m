Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYGIOde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYGIOde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYGIOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:33:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYGIOdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:33:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Date: Wed, 9 Jul 2008 16:35:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <20080708214903.b783ba84.randy.dunlap@oracle.com>
In-Reply-To: <20080708214903.b783ba84.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091635.22511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Randy Dunlap wrote:
> On Tue,  8 Jul 2008 23:37:43 +0200 (CEST) Rafael J. Wysocki wrote:
> 
> > Unresolved regressions
> > ----------------------
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> > Subject		: x86_64 boot hang when CONFIG_NUMA=n
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2008-06-05 21:50 (34 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> > 		  http://lkml.org/lkml/2008/6/11/355
> > 		  http://lkml.org/lkml/2008/6/15/117
> > 		  http://marc.info/?l=linux-kernel&m=121287638527452&w=2
> > Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> I've spent quite some time trying to bisect this problem, but to no avail.
> I don't expect to spend more time on it, so I suppose you can just mark it as dead.

OK, I'll close it, then.

Thanks,
Rafael
