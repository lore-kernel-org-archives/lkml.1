Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZKBJSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZKBJSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZKBJSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:18:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbZKBJSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:18:12 -0500
Date: Mon, 2 Nov 2009 10:18:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
Message-ID: <20091102091810.GA8933@elte.hu>
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* André Goddard Rosa <andre.goddard@gmail.com> wrote:

> >From f5d73ba151304056e4f7ea37e515493d1d3df38f Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
> Date: Fri, 30 Oct 2009 06:16:07 -0200
> Subject: [PATCH 03/16] trivial: fix assorted "through" typos
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> 
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
> b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
> index 446f867..0c7802b 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx3.h

> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index ad59a92..67e86b8 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c

Please _always_ generate a diffstat as well, so that people reviewing 
patches can see the scope of your patch at a glance.

	Ingo
