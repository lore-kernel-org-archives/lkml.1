Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYLPUFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYLPUFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYLPUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:05:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbYLPUFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:05:37 -0500
Date: Tue, 16 Dec 2008 21:05:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tej <bewith.tej@gmail.com>
Subject: Re: [PATCH] xen: whitespace/checkpatch cleanup
Message-ID: <20081216200524.GD4501@elte.hu>
References: <494807D6.9090106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494807D6.9090106@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Tej <bewith.tej@gmail.com>
>
> Signed-off-by: Tej <bewith.tej@gmail.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/enlighten.c  |   16 +++++++++-------
> arch/x86/xen/mmu.c        |   17 ++++++++++-------
> arch/x86/xen/multicalls.c |    2 +-
> arch/x86/xen/setup.c      |    9 +++++----
> 4 files changed, 25 insertions(+), 19 deletions(-)

applied to tip/x86/xen, thanks!

	Ingo
