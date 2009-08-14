Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbZHNOWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbZHNOWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbZHNOWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:22:24 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57860 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZHNOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:22:23 -0400
Date: Fri, 14 Aug 2009 16:22:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 00/15] clocksource / timekeeping rework V4 (resend V3 +
 bug fix)
Message-ID: <20090814162221.0d638f82@skybase>
In-Reply-To: <alpine.LFD.2.00.0908141608120.1283@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com>
	<alpine.LFD.2.00.0908141608120.1283@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009 16:08:57 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> > Keeping the fingers crossed that this is now really done.
> > John already gave his thumbs up for the patch series, so the next
> > logical question is who is going to sit on the patches until the merge
> > window is opened? I can certainly create a git branch on git390 for
> > them, but the patches depend on some patches in the x86-tip tree.
> > Thomas, any thoughts?
> 
> I'm going through them and pick them up into -tip.

Very good, thanks Thomas. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

