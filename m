Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZFIUxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZFIUxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 16:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZFIUxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 16:53:01 -0400
Received: from www.tglx.de ([62.245.132.106]:59454 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbZFIUxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 16:53:00 -0400
Date: Tue, 9 Jun 2009 22:52:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
In-Reply-To: <20090603152223.083010123@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
References: <20090603152223.083010123@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Martin Schwidefsky wrote:

> Greetings,
> version 2 of the profile patches. The only change is the in_interrupt()
> fix in tick_nohz_stop_idle(). I would like to know how to proceed with
> the issue.
> Andy, do you still prefer to handle the old style profiler analog to
> the oprofile patch? If yes I would drop patch #1 and extend patch #2
> with another tick_nohz_disable().

Any update on this one ?

Thanks,

	tglx
