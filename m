Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYGaKqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYGaKqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYGaKqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:46:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYGaKqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:46:19 -0400
Date: Thu, 31 Jul 2008 12:45:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Keller <jpk@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND] [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
Message-ID: <20080731104510.GI488@elte.hu>
References: <20080715194714.1437.92354.57492@attica.americas.sgi.com> <200807291934.m6TJYGai478010@fcbayern.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807291934.m6TJYGai478010@fcbayern.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0595]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Keller <jpk@sgi.com> wrote:

> Just checking on the status of this patch.
> If there are no issues, please apply.

> SGI UV will have MMCFG base addresses that are greater than 4GB (32 bits).

applied to tip/x86/uv, thanks John.

	Ingo
