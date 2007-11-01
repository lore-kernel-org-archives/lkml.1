Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbXKAI3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbXKAI3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXKAI3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:29:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbXKAI3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:29:23 -0400
Date: Thu, 1 Nov 2007 09:29:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH 0/6] various scheduler patches
Message-ID: <20071101082915.GA8459@elte.hu>
References: <20071031211030.310581000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031211030.310581000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0860]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> My current scheduler queue, seems to work well on lappy

nice stuff! Both the hrtimers-tick feature and the rtlimit looks pretty 
good. I'm wondering how well it works on SMP?

	Ingo
