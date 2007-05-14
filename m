Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbXENCVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbXENCVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 22:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXENCVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 22:21:32 -0400
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:35770 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbXENCVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 22:21:32 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: Swap prefetch tester
Date: Mon, 14 May 2007 12:17:56 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org
References: <200705141210.43614.kernel@kolivas.org>
In-Reply-To: <200705141210.43614.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141217.57142.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 12:10, Con Kolivas wrote:
> I've had a few requests for a standalone patch implementing swap prefetch
> for mainline.
>
> Here is a patch that is a current rollup that should apply and work for
> vanilla 2.6.21 (ie not a -ck kernel):
>
> http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch

Oh and here is the swap prefetch tester:
http://ck.kolivas.org/patches/swap-prefetch/sp_tester.c

-- 
-ck
