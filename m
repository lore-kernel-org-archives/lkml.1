Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZKDNkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZKDNkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbZKDNkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:40:46 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:60456 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbZKDNko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:40:44 -0500
Date: Wed, 4 Nov 2009 14:40:52 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       linux-s390@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] nohz tweaking
Message-ID: <20091104144052.0b4e99e1@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0909301204460.2756@nanos>
References: <20090929122514.693636761@de.ibm.com>
	<alpine.LFD.2.00.0909301204460.2756@nanos>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin Thomas,

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

I could not find the patches on tip timers/core. Where did you put them ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

