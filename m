Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbXK1WTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbXK1WTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXK1WTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:19:05 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:26490 "EHLO
	outbound4-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbXK1WTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:19:04 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <474DE952.6000304@am.sony.com>
Date: Wed, 28 Nov 2007 14:18:58 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/7] ps3: Add ps3_repository_find_device_by_id()
References: <20071128143142.580732000@pademelon.sonytel.be> <20071128143438.201413000@pademelon.sonytel.be>
In-Reply-To: <20071128143438.201413000@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2007 22:19:00.0005 (UTC) FILETIME=[ACCB2550:01C8320C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ps3: Add ps3_repository_find_device_by_id()
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/platforms/ps3/platform.h   |    2 
>  arch/powerpc/platforms/ps3/repository.c |   77 ++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)

Looks good.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

