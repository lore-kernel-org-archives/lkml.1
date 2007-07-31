Return-Path: <linux-kernel-owner+w=401wt.eu-S934919AbXGaWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919AbXGaWAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760065AbXGaWAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:00:19 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:32389 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbXGaWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:00:17 -0400
Date: Tue, 31 Jul 2007 15:00:07 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-driver@qlogic.com,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 64] drivers/scsi/qla2xxx/qla_init.c: mostly kmalloc + memset conversion to k[cz]alloc
Message-ID: <20070731220007.GI8842@plap.qlogic.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312351.10536.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707312351.10536.m.kozlowski@tuxland.pl>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 31 Jul 2007 21:59:21.0548 (UTC) FILETIME=[0CCEE0C0:01C7D3BE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, Mariusz Kozlowski wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/qla2xxx/qla_init.c | 107445 -> 107327 (-118 bytes)
>  drivers/scsi/qla2xxx/qla_init.o | 237540 -> 237424 (-116 bytes)
> 
>  drivers/scsi/qla2xxx/qla_init.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
