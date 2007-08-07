Return-Path: <linux-kernel-owner+w=401wt.eu-S934842AbXHGWIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbXHGWIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937680AbXHGV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:57:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50610 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936844AbXHGV5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:57:38 -0400
Message-ID: <46B8EAD0.2040303@pobox.com>
Date: Tue, 07 Aug 2007 17:57:36 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 68] drivers/net/s2io.c: kmalloc + memset conversion to
 k[cz]alloc
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312356.58934.m.kozlowski@tuxland.pl>
In-Reply-To: <200707312356.58934.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.2 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.2 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/s2io.c | 235587 -> 235340 (-247 bytes)
>  drivers/net/s2io.o | 460768 -> 460120 (-648 bytes)
> 
>  drivers/net/s2io.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)

ACK but didn't apply, please wait 24-48 hours (so that s2io fixes go 
upstream), then rediff and resend


