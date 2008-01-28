Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYA1Mkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYA1Mkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYA1Mkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:40:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYA1Mkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:40:41 -0500
Date: Mon, 28 Jan 2008 13:40:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: not set boot cpu in cpu_present_map again
Message-ID: <20080128124032.GB32496@elte.hu>
References: <200801271827.17992.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801271827.17992.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1468]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: not set boot cpu in cpu_present_map again
> 
> in init/main.c boot_cpu_init() already does that before setup_arch

thanks, applied.

	Ingo
