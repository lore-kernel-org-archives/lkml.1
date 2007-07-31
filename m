Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbXGaWfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbXGaWfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbXGaWfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:35:04 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:38828 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbXGaWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:35:01 -0400
Date: Wed, 1 Aug 2007 00:32:47 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 76] drivers/net/via-velocity.c: mostly kmalloc + memset conversion to kcalloc
Message-ID: <20070731223247.GA22528@electric-eye.fr.zoreil.com>
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200708010011.50979.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708010011.50979.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski <m.kozlowski@tuxland.pl> :
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/via-velocity.c | 88263 -> 88120 (-143 bytes)
>  drivers/net/via-velocity.o | 254264 -> 253828 (-436 bytes)
> 
>  drivers/net/via-velocity.c |   24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
