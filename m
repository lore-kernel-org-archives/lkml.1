Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYFSMLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYFSMLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYFSMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:11:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33367 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbYFSMLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:11:25 -0400
Date: Thu, 19 Jun 2008 14:11:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup machine_specific_memory_setup v2
Message-ID: <20080619121108.GB7640@elte.hu>
References: <200806161303.31997.yhlu.kernel@gmail.com> <200806161958.28627.yhlu.kernel@gmail.com> <200806181106.08491.yhlu.kernel@gmail.com> <200806181727.08918.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806181727.08918.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0026]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 1. let 64bit support 88 and e801 too
> 2. introduce default_machine_specific_memory_setup, and reuse it
>    for voyager
> 
> v2: fix 64 bit compiling

applied to tip/x86/mpparse - thanks Yinghai.

	Ingo
