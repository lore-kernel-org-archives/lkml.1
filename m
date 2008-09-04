Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYIDUy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYIDUy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYIDUyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:54:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106AbYIDUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:54:17 -0400
Date: Thu, 4 Sep 2008 13:53:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <20080904204305.GA29065@elte.hu>
Message-ID: <alpine.LFD.1.10.0809041350350.3117@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
 <20080904204305.GA29065@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Ingo Molnar wrote:
> 
> if you are happy with the commit below, could you please give your 
> Signed-off-by for it?

Sure.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

		Linus
