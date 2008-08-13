Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYHMLLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYHMLLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYHMLLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:11:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYHMLLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:11:05 -0400
Date: Wed, 13 Aug 2008 13:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix 2 section mismatch warnings -
	find_and_reserve_crashkernel
Message-ID: <20080813111051.GA18660@elte.hu>
References: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com>
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


applied these fixes of yours to tip/x86/urgent:

# f0b0d88: x86: fix 2 section mismatch warnings - find_and_reserve_crashkernel
# 844342a: x86: fix section mismatch warning - spp_getpage()
# c9d08f0: x86: fix 2 section mismatch warnings - map_high()

thanks Marcin.

	Ingo
