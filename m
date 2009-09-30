Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZI3Lhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZI3Lhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZI3Lhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:37:51 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:53561 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZI3Lhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:37:50 -0400
Date: Wed, 30 Sep 2009 13:37:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] nohz tweaking
Message-ID: <20090930133751.30633106@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0909301204460.2756@nanos>
References: <20090929122514.693636761@de.ibm.com>
	<alpine.LFD.2.00.0909301204460.2756@nanos>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 12:06:42 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Martin,
> 
> On Tue, 29 Sep 2009, Martin Schwidefsky wrote:
> 
> > Greetings,
> > the two remainting patches of the nohz performance work I've been
> > doing. Both have been sent to the mailing lists before. Ingo had
> > a comment about patch #1, but no one but me seems to be interested
> > in patch #2. Neverless I would like to get both patches upstream.
> > I can create a branch for them on git390 but I feel that they should
> > go the path all the other nohz/time/clocksource patches went.
> 
> Sorry, that's my fault. I forgot them over the watchdog
> wreckage. Picking them up now.

Thats great, thanks. And yes the clocksource/watchdog problems have
been painful..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

