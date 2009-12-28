Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZL1LXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZL1LXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZL1LXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:23:17 -0500
Received: from relay.atmel.no ([80.232.32.139]:50497 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZL1LXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:23:17 -0500
Date: Mon, 28 Dec 2009 12:23:01 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Peter =?UTF-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: Re: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Message-ID: <20091228122301.53642d9f@hcegtvedt.norway.atmel.com>
In-Reply-To: <20091228120723.6a22367e@hcegtvedt.norway.atmel.com>
References: <200912252008.45602.PeterHuewe@gmx.de>
	<200912281059.30450.PeterHuewe@gmx.de>
	<20091228112028.5babace2@hskinnemoen-d830>
	<200912281134.36763.PeterHuewe@gmx.de>
	<20091228120723.6a22367e@hcegtvedt.norway.atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 12:07:23 +0100
Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

> On Mon, 28 Dec 2009 11:34:36 +0100
> Peter Hüwe <PeterHuewe@gmx.de> wrote:

<snipp>

> > > I think your first patch is good as it is, so I will apply it. Please
> > > send any additional fixes as a separate patch.
> > 
> > Okay thanks for applying.
> > 
> > @Hans: can you create the cleanup patch or should I ?
> > 
> 
> I'll do it, should arrive here shortly.
>

"here", by here I actually meant to the kernel@avr32linux.org mailing
list[1]. So I hope Håvard will snap it from there.

Sadly I just realized that the archives has been non functional since
mid November due to server misconfiguration. Fixed now.

1: http://lists.avr32linux.org/pipermail/kernel/2009-December/005484.html

-- 
Best regards,
Hans-Christian Egtvedt
