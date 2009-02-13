Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZBMSOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZBMSOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZBMSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:13:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZBMSN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:13:56 -0500
Date: Fri, 13 Feb 2009 19:13:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] UV: set full apicid in uv_hub_send_ipi
Message-ID: <20090213181344.GG18581@elte.hu>
References: <20090212215234.GA9808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212215234.GA9808@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> The uv_hub_send_ipi() function needs to set the full apicid in the
> UVH_IPI_INT mmr.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> Acked-by: Jack Steiner <steiner@sgi.org>

Applied to tip:x86/apic, thanks Dimitri!

	Ingo
