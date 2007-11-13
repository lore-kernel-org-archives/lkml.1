Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXKMUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXKMUBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbXKMUBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:01:21 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:45086 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759104AbXKMUBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:01:20 -0500
Date: Tue, 13 Nov 2007 21:00:30 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <20071113110259.44c56d42.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net>
 <20071113110259.44c56d42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Andrew Morton wrote:
> I think that we're fairly good about working the regressions in
> Adrian/Michal/Rafael's lists but once Linus releases 2.6.x we tend to let
> the unsolved ones slide, and we don't pay as much attention to the
> regressions which 2.6.x testers report.

Can't we wait until all regressions[0] are fixed before releasing a new 
2.6.x? I'd consider regressions a *literal* show stopper, and with this 
policy they just have be fixed, nothing would "slide"...

my 2 cents,
Christian.

[0] preferably only reproducible regressions, with responsive reporters.
-- 
BOFH excuse #380:

Operators killed when huge stack of backup tapes fell over.
