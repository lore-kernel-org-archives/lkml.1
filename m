Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbXHGWKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbXHGWKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936890AbXHGV56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:57:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50631 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937780AbXHGV5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:57:54 -0400
Message-ID: <46B8EADE.3030705@garzik.org>
Date: Tue, 07 Aug 2007 17:57:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, romieu@fr.zoreil.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 76] drivers/net/via-velocity.c: mostly kmalloc + memset
 conversion to kcalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200708010011.50979.m.kozlowski@tuxland.pl>
In-Reply-To: <200708010011.50979.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/via-velocity.c | 88263 -> 88120 (-143 bytes)
>  drivers/net/via-velocity.o | 254264 -> 253828 (-436 bytes)
> 
>  drivers/net/via-velocity.c |   24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

applied


