Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYKZCyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYKZCyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYKZCx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:53:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYKZCx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:53:57 -0500
Date: Wed, 26 Nov 2008 03:53:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: fixup config space size of CPU functions for AMD
	family 11h
Message-ID: <20081126025349.GE31342@elte.hu>
References: <20081125161803.GG17422@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125161803.GG17422@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/pci/fixup.c |   25 ++++++++++++++-----------
>  1 files changed, 14 insertions(+), 11 deletions(-)

applied to tip/x86/urgent, thanks Andreas!

	Ingo
