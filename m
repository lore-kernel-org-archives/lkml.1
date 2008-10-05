Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbYJEQom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbYJEQom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbYJEQkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:40:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759555AbYJEQkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:40:04 -0400
Date: Sun, 5 Oct 2008 18:39:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Januszewski <spock@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: replace a magic number with a named constant in
	the VESA boot code
Message-ID: <20081005163949.GA18181@elte.hu>
References: <20081005101604.GA1995@spock.one.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005101604.GA1995@spock.one.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Januszewski <spock@gentoo.org> wrote:

> Replace a magic number with a named constant in the VESA boot code.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
> diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c

applied to tip/x86/setup, thanks Michal!

	Ingo
