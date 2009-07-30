Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZG3XuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZG3XuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZG3XuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:50:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbZG3XuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:50:10 -0400
Date: Thu, 30 Jul 2009 16:49:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timers fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Jul 2009, Thomas Gleixner wrote:
> 
> Please pull the latest timers-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> 
> Thanks,
> 
> 	tglx
> 
> ------------------>
> Magnus Damm (1):
>       clocksource: save mult_orig in clocksource_disable()
> 
>  include/linux/clocksource.h |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)

Hmm. You seem to have forgotten to push this out. I realize you're off to 
vacation, do you have time to check that?

		Linus
