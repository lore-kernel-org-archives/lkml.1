Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZFVWEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZFVWEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZFVWEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:04:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:34501 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751347AbZFVWEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:04:35 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/dfKwbGAzdoPhcRk25XM744XLyPsY0rmJrdmH1ZU
	WL+ML/8y3ibBoU
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: trivial@kernel.org
Subject: Re: [PATCH] block: adding __init/__exit macros to DAC960.c
Date: Tue, 23 Jun 2009 00:04:36 +0200
User-Agent: KMail/1.9.9
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906121307.29865.PeterHuewe@gmx.de>
In-Reply-To: <200906121307.29865.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230004.36995.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 12 Juni 2009 13:07:29 schrieb Peter Huewe:
> From: Peter Huewe <peterhuewe@gmx.de>
>
> Trivial patch which adds the __init and __exit macros to the module_init /
> module_exit functions from drivers/block/DAC960.c
> linux version 2.6.30
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Hi, 
@Jiri:
I was wondering if there is anything wrong with the patch or is it still in 
the review phase ?


Best Regards,
Peter
