Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYGKIUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYGKIUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYGKIUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:20:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYGKIUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:20:37 -0400
Date: Fri, 11 Jul 2008 10:20:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] x86: e820 remove the range instead of update it to
	reserved
Message-ID: <20080711082021.GA4427@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807100417.00285.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100417.00285.yhlu.kernel@gmail.com>
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

> also let mem= to print out modified e820 map too
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/core - thanks Yinghai.

	Ingo
