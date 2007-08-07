Return-Path: <linux-kernel-owner+w=401wt.eu-S936693AbXHGWJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936693AbXHGWJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXHGV5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:57:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50626 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936784AbXHGV5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:57:45 -0400
Message-ID: <46B8EAD7.2040105@pobox.com>
Date: Tue, 07 Aug 2007 17:57:43 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 69] drivers/net/sb1250-mac.c: kmalloc + memset conversion
 to kcalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312358.36567.m.kozlowski@tuxland.pl>
In-Reply-To: <200707312358.36567.m.kozlowski@tuxland.pl>
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
>  drivers/net/sb1250-mac.c | 76286 -> 76199 (-87 bytes)
> 
>  drivers/net/sb1250-mac.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

applied


