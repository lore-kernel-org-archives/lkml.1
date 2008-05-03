Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbYECSRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbYECSRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbYECSRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:17:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673AbYECSRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:17:15 -0400
Date: Sat, 3 May 2008 20:16:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, sfr@canb.auug.org.au,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: x86_64 does not boot in Qemu
Message-ID: <20080503181657.GE5292@elte.hu>
References: <48191E75.70305@gmail.com> <4819AB03.3030808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4819AB03.3030808@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Hi Dmitri,
> 
> There are 3 "fix" patches after this one (sorry about that).
> 
> 	http://marc.info/?l=linux-kernel&m=120941725114635&w=4
> 	http://marc.info/?l=linux-kernel&m=120949583029044&w=4
> 	http://marc.info/?l=linux-kernel&m=120956778620842&w=4
> 
> Checking out the "latest" sched/latest it appears though that the 
> entire patchset has been removed.  I'll wait for Ingo's feedback on 
> what's up.

yep - i found boot regressions and pulled the changes and notified you. 
I'll merge your last fix for it and reactivate.

	Ingo
