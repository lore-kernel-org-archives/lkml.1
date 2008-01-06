Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYAFNAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYAFNAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYAFM7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:59:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYAFM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:59:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Date: Sun, 6 Jan 2008 13:56:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>
References: <200801052042.56042.rjw@sisk.pl> <20080106093853.GD26291@elte.hu>
In-Reply-To: <20080106093853.GD26291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061356.53804.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Subject		: jiffies counter leaps in 2.6.24-rc3
> > Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> > Date		: 2007-11-29 08:36
> > References	: http://lkml.org/lkml/2007/11/24/53
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > Patch		: http://lkml.org/lkml/2007/12/7/132
> 
> this holds a series of problems, we've applied everything we wanted to 
> 2.6.24 already we'll do the full stack of fixes for this in 2.6.25. 
> (changing printk was deemed inappropriate so late in the -rc cycle) So 
> perhaps mark this as WILL_FIX_LATER and unmark it as a regression? 

I'll be fine with that if Stefano agrees.

Thanks,
Rafael
