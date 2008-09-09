Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYIIG55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYIIG55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYIIG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:57:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYIIG5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:57:49 -0400
Date: Tue, 9 Sep 2008 08:57:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unused variable in dma_alloc_coherent_gfp_flags()
Message-ID: <20080909065736.GC27747@elte.hu>
References: <1220915951-11434-1-git-send-email-steven@uplinklabs.net> <1220915951-11434-2-git-send-email-steven@uplinklabs.net> <1220915951-11434-3-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220915951-11434-3-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> Fixed a warning caused by a badly placed ifdef.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

applied to tip/x86/iommu - thanks Steven,

	Ingo
