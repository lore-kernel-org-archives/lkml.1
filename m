Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXK1Wv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXK1Wv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbXK1WvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:51:17 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:60447 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761504AbXK1WvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:51:16 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <474DF057.2060906@am.sony.com>
Date: Wed, 28 Nov 2007 14:48:55 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 6/7] ps3: Refactor ps3_repository_find_device()
References: <20071128143142.580732000@pademelon.sonytel.be> <20071128143438.613525000@pademelon.sonytel.be>
In-Reply-To: <20071128143438.613525000@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2007 22:48:57.0021 (UTC) FILETIME=[DBE606D0:01C83210]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> ps3: Refactor ps3_repository_find_device() to use the existing
> ps3_repository_read_bus_id()
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/platforms/ps3/repository.c |   60 +++++++++++---------------------
>  1 files changed, 22 insertions(+), 38 deletions(-)

Looks good.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

