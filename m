Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYHGIG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYHGIG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 04:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYHGIAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:00:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbYHGIAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:00:31 -0400
Message-ID: <489AAB9B.1010107@garzik.org>
Date: Thu, 07 Aug 2008 04:00:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WAN: remove extra help text from HDLC_PPP config option
References: <m3vdzq4rdg.fsf@maximus.localdomain>
In-Reply-To: <m3vdzq4rdg.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Remove extra help text from HDLC_PPP config option.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
> index d3c2773..8f3ac39 100644
> --- a/drivers/net/wan/Kconfig
> +++ b/drivers/net/wan/Kconfig
> @@ -154,8 +154,6 @@ config HDLC_PPP
>  	help
>  	  Generic HDLC driver supporting PPP over WAN connections.
>  
> -	  It will be replaced by new PPP implementation in Linux 2.6.26.
> -
>  	  If unsure, say N.

applied


