Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYKQJsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYKQJsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYKQJrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:47:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYKQJry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:47:54 -0500
Date: Mon, 17 Nov 2008 10:47:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] trivial, entry_64: remove whitespace at end of lines
Message-ID: <20081117094740.GK28786@elte.hu>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> All blame goes to: color white,red "[^[:graph:]]+$"
> in .nanorc ;).
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> ---
>  arch/x86/kernel/entry_64.S |  200 ++++++++++++++++++++++----------------------
>  1 files changed, 100 insertions(+), 100 deletions(-)

applied to tip/x86/cleanups, thanks Alexander. This file still has a 
horrible code structure but now at least our eyes do not burn out when 
looking at it ;-)

	Ingo
