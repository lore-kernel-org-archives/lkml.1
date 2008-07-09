Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYGIFuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYGIFuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 01:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYGIFuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 01:50:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYGIFuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 01:50:24 -0400
Date: Wed, 9 Jul 2008 07:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Bernhard Walle <bwalle@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: move saving e820_saved to setup_memory_map
Message-ID: <20080709055003.GA9760@elte.hu>
References: <200807031135.37465.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807031135.37465.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> so other path that will override memory_setup or 
> machine_specific_memory_setup could have e820_saved too

applied to tip/x86/core, thanks Yinghai.

	Ingo
