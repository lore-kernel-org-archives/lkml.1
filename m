Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYFROV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYFROV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYFROVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:21:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYFROVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:21:49 -0400
Date: Wed, 18 Jun 2008 16:21:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use acpi_numa_init to parse on 32bit numa
Message-ID: <20080618142135.GH11501@elte.hu>
References: <200806171002.45836.yhlu.kernel@gmail.com> <200806171541.45739.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806171541.45739.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> seperate that srat finding and parsing from get_memcfg_from_srat. and 
> let getmemcfg_from_srat only handle array from previous step.

applied to tip/x86/mpparse, thanks Yinghai.

	Ingo
