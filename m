Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbYGCMOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbYGCMOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYGCMOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:14:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbYGCMOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:14:01 -0400
Date: Thu, 3 Jul 2008 14:13:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.26-rc6] section/warning fixes...
Message-ID: <20080703121318.GA11551@elte.hu>
References: <6278d2220806150432i6f8265bfra7d0e5ff6e130303@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220806150432i6f8265bfra7d0e5ff6e130303@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> This fixes [2] some warnings [1] introduced in recent -rc series; 
> please apply.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

thanks - most of this went upstream via tip/x86/urgent -> upstream. The 
upstream commit is:

| commit 0b1faeef5f9243bb5fc5713a34bbf1ceab0de562
| Author: Daniel J Blueman <daniel.blueman@gmail.com>
| Date:   Sun Jun 15 12:32:15 2008 +0100
|
|    x86: section/warning fixes

	Ingo
