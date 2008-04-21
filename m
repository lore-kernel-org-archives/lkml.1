Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYDUMZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYDUMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYDUMZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:25:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbYDUMZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:25:14 -0400
Date: Mon, 21 Apr 2008 14:25:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: random clean-ups
Message-ID: <20080421122504.GF6788@elte.hu>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0362]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Hi Ingo, Peter, Thomas,
> 
> The following patches contain a few clean-ups, mostly stemming from 
> analyzis of sparse messages.
> 
> The patches are against current x86.git.

thanks Dmitri, applied #1/#2/#4, as per the discussion.

	Ingo
