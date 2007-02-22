Return-Path: <linux-kernel-owner+w=401wt.eu-S1750789AbXBVKzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750789AbXBVKzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXBVKzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:55:19 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:47423 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXBVKzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:55:18 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <f1a1f4524ebd07f21e1hjzxo0007rhck@thunder.lp0.eu>
Subject: Re: [PATCH] MAINTAINERS: Add myself for cxacru (in drivers/usb/atm/)
Date: Thu, 22 Feb 2007 11:55:09 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45DCC156.7010308@simon.arlott.org.uk>
In-Reply-To: <45DCC156.7010308@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221155.09766.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 23:01:58 Simon Arlott wrote:
> I've acquired a second device for testing and plan to make some changes
> in the near future to export all the device stats to sysfs (based on my
> proposed patch to add them to the proc file ~2007-01-30).
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
>  MAINTAINERS |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b0fd71b..2970154 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -934,6 +934,11 @@ M:	mhw@wittsend.com
>  W:	http://www.wittsend.com/computone.html
>  S:	Maintained
>  
> +CONEXANT ACCESSRUNNER USB DRIVER
> +P:	Simon Arlott
> +M:	cxacru@fire.lp0.eu
> +S:	Maintained
> +
>  COSA/SRP SYNC SERIAL DRIVER
>  P:	Jan "Yenya" Kasprzak
>  M:	kas@fi.muni.cz
> -- 
> 1.4.3.1
> 
> 

You may want to put something in the cxacru driver too.

Acked-by: Duncan Sands <baldrick@free.fr>
