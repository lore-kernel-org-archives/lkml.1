Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbXKWMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbXKWMXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbXKWMX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:23:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbXKWMX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:23:26 -0500
Date: Fri, 23 Nov 2007 13:23:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Durand <titetan@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071123122311.GA6685@elte.hu>
References: <248019.51681.qm@web51602.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <248019.51681.qm@web51602.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Durand <titetan@yahoo.com> wrote:

> Ingo,
> 
> Just applied this patch to 2.6.22.13 and 2.6.22.14. Compiles and runs 
> fine but on my laptop, it prevents suspending and hibernating with 
> "one tasks refuses to freeze" load_balance_mo.

please re-download the v24 patch, it should have this bug fixed.

	Ingo
