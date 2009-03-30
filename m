Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZC3IpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZC3IpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZC3IpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:45:07 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56491 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZC3IpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hrTwdO40sYZf/EJSKne7tfwjdV8HstzkNtaoKlIFXPdolgdUm478A8bNdNvZny0G7E
         uQc0vOCxSg7HYnQY/E+bug7MJ96IjJnMe3/tl/0qQtMDPvPUqJIfSHsjlNZx9zsaLnYR
         vwtgL0ik1cGgqNN4VIs/CZlwFJ2m+4VndiqWM=
From: Florian Fainelli <florian@openwrt.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] spi: Add support for the OpenCores SPI controller.
Date: Mon, 30 Mar 2009 10:44:54 +0200
User-Agent: KMail/1.9.9
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1238054874-28215-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1238054874-28215-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301044.54626.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Le Thursday 26 March 2009 09:07:53 Thierry Reding, vous avez écrit :
> This patch adds a platform device driver that supports the OpenCores SPI
> controller.
>
> The driver expects two resources: an IORESOURCE_MEM resource defining the
> core's memory-mapped registers and an IORESOURCE_IRQ for the associated
> interrupt. It also requires a clock, "spi-master-clk", used to compute the
> clock divider.

Thanks again for submitting this ;)

>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Acked-by: Florian Fainelli <florian@openwrt.org>

-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
