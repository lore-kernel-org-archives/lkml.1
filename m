Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYCWTHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYCWTHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbYCWTHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:07:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51605 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYCWTHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:07:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
Date: Sun, 23 Mar 2008 20:06:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803170018.52663.rjw@sisk.pl> <alpine.DEB.1.00.0803231955530.13579@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803231955530.13579@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803232006.57198.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of March 2008, Christian Kujau wrote:
> Hi Rafael,
> 
> On Mon, 17 Mar 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> > Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > Date		: 2008-03-07 21:32 (10 days old)
> > References	: http://lkml.org/lkml/2008/3/7/308
> > 		  http://lkml.org/lkml/2008/3/9/186
> >
> 
> The other Christian reported this as fixed: http://lkml.org/lkml/2008/3/17/232
> I too can confirm that the hangs are gone now: http://lkml.org/lkml/2008/3/21/532

Is the patch present in the mainline yet?

> Thanks for maintaining the regression list,

You're welcome. :-)

Thanks,
Rafael
