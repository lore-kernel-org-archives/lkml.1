Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYFRO1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYFRO1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYFRO0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:26:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYFRO0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:26:51 -0400
Date: Wed, 18 Jun 2008 16:26:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: move some function out of setup_bootmem_alloc
Message-ID: <20080618142638.GJ11501@elte.hu>
References: <200806171002.45836.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806171002.45836.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> so make it more like 64 bit

applied to tip/x86/mpparse. Thanks,

	Ingo
