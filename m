Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYJ0NX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYJ0NX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYJ0NXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:23:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYJ0NXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:23:15 -0400
Date: Mon, 27 Oct 2008 14:23:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan McGee <dpmcgee@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] Remove IRQBALANCE crud
Message-ID: <20081027132307.GG25371@elte.hu>
References: <1224794642-30350-1-git-send-email-dpmcgee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224794642-30350-1-git-send-email-dpmcgee@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan McGee <dpmcgee@gmail.com> wrote:

> CONFIG_IRQBALANCE was removed in commit 8b8e8c1bf; this ifdef was still
> around.
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>
> ---
>  arch/x86/include/asm/irq.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)

good catch - applied to tip/x86/cleanups, thanks Dan!

	Ingo
