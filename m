Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZCDU7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZCDU7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZCDU6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:58:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZCDU6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:58:52 -0500
Date: Wed, 4 Mar 2009 21:58:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/3 v7] SGI RTC: fix uv_time for UP
Message-ID: <20090304205833.GB3527@elte.hu>
References: <20090304185413.GA24385@sgi.com> <20090304194658.GA18096@elte.hu> <20090304204522.GA25430@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304204522.GA25430@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> Fix UP build of uv_time.c.

it's not against tip:x86/uv as i asked ...

(i did a few cleanups of the file so your patch does not apply.)

If you have -tip as a remote you can check it out via:

  git checkout tip/x86/uv

	Ingo
