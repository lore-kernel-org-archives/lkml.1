Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYDJMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYDJMCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbYDJMCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:02:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYDJMCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:02:09 -0400
Date: Thu, 10 Apr 2008 14:01:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [patch x86] e820_64: fix section mismatch warning
Message-ID: <20080410120155.GA18032@elte.hu>
References: <47FDFCC9.5070106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FDFCC9.5070106@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0201]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

> Hi Ingo,
>
> this patch (against x86/latest) fixes section mismatch warnings which 
> occurs on my x86_64 box while compiling linux-next-20080410.

thanks Jacek, applied.

	Ingo
