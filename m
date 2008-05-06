Return-Path: <linux-kernel-owner+w=401wt.eu-S1762747AbYEFMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747AbYEFMjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbYEFMjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:39:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761755AbYEFMjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:39:03 -0400
Date: Tue, 6 May 2008 14:38:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use correct format when printing long unsigned int in
	arch/x86/kernel/setup.c
Message-ID: <20080506123847.GP32591@elte.hu>
References: <alpine.LNX.1.00.0805060039100.27779@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0805060039100.27779@dragon.funnycrock.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0540]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesper Juhl <jesper.juhl@gmail.com> wrote:

> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> Use correct format when printing long unsigned int in arch/x86/kernel/setup.c

applied, thanks Jesper.

	Ingo
