Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYFJKfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYFJKfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYFJKe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:34:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57705 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYFJKe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:34:56 -0400
Date: Tue, 10 Jun 2008 12:34:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [patch] x86: coding style fixes to arch/x86/pci/irq.
Message-ID: <20080610103443.GI19136@elte.hu>
References: <20080607141435.0ab5fa48@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607141435.0ab5fa48@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 60 errors, 85 warnings, 1237 lines checked
> 
> After:
> total: 1 errors, 82 warnings, 1226 lines checked
> 
> WARNING: line over 80 characters
> 
> Compile tested.
> 
> paolo@paolo-desktop:/tmp$ size irq.o.*
>    text    data     bss     dec     hex filename
>    6128     440      76    6644    19f4 irq.o.after
>    6128     440      76    6644    19f4 irq.o.before

applied to tip/x86/cleanups, thanks Paolo.

	Ingo
