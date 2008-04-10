Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbYDJUOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbYDJUOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbYDJUN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:13:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbYDJUN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:13:58 -0400
Date: Thu, 10 Apr 2008 22:13:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>
Subject: Re: x86 git tree broken
Message-ID: <20080410201339.GD4323@elte.hu>
References: <200804102159.14563.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804102159.14563.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> The x86 git tree, as of HEAD commit
> 
> commit a9efd1225e6e0e78ceeaecc04cec1d428eb8173f
> Author: Mike Travis <travis@sgi.com>
> Date:   Fri Apr 4 18:30:16 2008 -0700
> 
>     x86: modify Kconfig to allow up to 4096 cpus
> 
> doesn't want to work on one of my testboxes (x86-64 desktop, 
> AMD-based).
> 
> First, the X server doesn't want to start (it says it couldn't mmap 
> the framebuffer).

could you send your .config?

	Ingo
