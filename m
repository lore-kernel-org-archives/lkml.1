Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYHKK6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYHKK6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYHKK6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:58:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbYHKK6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:58:35 -0400
Date: Mon, 11 Aug 2008 12:58:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: arch/x86/kernel/cpuid.c: removed duplicated #include
Message-ID: <20080811105820.GA6925@elte.hu>
References: <20080810210512.2EFD.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810210512.2EFD.WEIYI.HUANG@gmail.com>
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


* Huang Weiyi <weiyi.huang@gmail.com> wrote:

> Removed duplicated include file <linux/smp_lock.h> in 
> arch/x86/kernel/cpuid.c.

applied to tip/x86/cleanups - thanks.

	Ingo
