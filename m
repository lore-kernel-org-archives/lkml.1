Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbXELQZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbXELQZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbXELQZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:25:38 -0400
Received: from mail.suse.de ([195.135.220.2]:36310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbXELQZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:25:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH] spelling fixes: arch/x86_64/
Date: Sat, 12 May 2007 18:25:26 +0200
User-Agent: KMail/1.9.6
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
References: <4644C783.3090805@simon.arlott.org.uk>
In-Reply-To: <4644C783.3090805@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121825.26430.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +++ b/arch/x86_64/kernel/signal.c
> @@ -411,7 +411,7 @@ static void do_signal(struct pt_regs *regs)
>  
>  	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
>  	if (signr > 0) {
> -		/* Reenable any watchpoints before delivering the
> +		/* Re-enable any watchpoints before delivering the

reenable gets >140k google hits so it seems to be an really used word.
Similar with upto.

-Andi
