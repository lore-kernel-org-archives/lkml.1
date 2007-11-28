Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXK1WqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXK1WqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbXK1WqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:46:14 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:13802 "EHLO
	mail112-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbXK1WqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:46:12 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <474DEFAB.6040000@am.sony.com>
Date: Wed, 28 Nov 2007 14:46:03 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 5/7] ps3: Kill unused ps3_repository_bump_device()
References: <20071128143142.580732000@pademelon.sonytel.be> <20071128143438.547001000@pademelon.sonytel.be>
In-Reply-To: <20071128143438.547001000@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2007 22:46:07.0912 (UTC) FILETIME=[771A0A80:01C83210]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> ps3: Kill unused ps3_repository_bump_device()
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/platforms/ps3/platform.h |    6 ------
>  1 files changed, 6 deletions(-)

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

