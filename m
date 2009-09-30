Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZI3KG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZI3KG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZI3KG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:06:58 -0400
Received: from www.tglx.de ([62.245.132.106]:53373 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbZI3KG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:06:57 -0400
Date: Wed, 30 Sep 2009 12:06:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] nohz tweaking
In-Reply-To: <20090929122514.693636761@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0909301204460.2756@nanos>
References: <20090929122514.693636761@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin,

On Tue, 29 Sep 2009, Martin Schwidefsky wrote:

> Greetings,
> the two remainting patches of the nohz performance work I've been
> doing. Both have been sent to the mailing lists before. Ingo had
> a comment about patch #1, but no one but me seems to be interested
> in patch #2. Neverless I would like to get both patches upstream.
> I can create a branch for them on git390 but I feel that they should
> go the path all the other nohz/time/clocksource patches went.

Sorry, that's my fault. I forgot them over the watchdog
wreckage. Picking them up now.

Thanks,

	tglx
