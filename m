Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYK3GqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYK3GqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 01:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYK3Gpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 01:45:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYK3Gpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 01:45:52 -0500
Date: Sun, 30 Nov 2008 07:45:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: intel_cacheinfo, minor show_type cleanup
Message-ID: <20081130064538.GA27406@elte.hu>
References: <1227994396-20170-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227994396-20170-1-git-send-email-jirislaby@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)

applied to tip/x86/cleanups, thanks Jiri!

	Ingo
