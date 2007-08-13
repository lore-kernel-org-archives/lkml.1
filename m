Return-Path: <linux-kernel-owner+w=401wt.eu-S974116AbXHMS0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974116AbXHMS0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765483AbXHMSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:06:36 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:52788 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S973457AbXHMSGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:06:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=X/7yHO2dexHOHNOeZN+MA+4EJaOzWnx4eyhr9KsQ6JofmTbB2JzmoR3rglCc0vnPq4vgjfECP7RGW/m1IK7xY8ULJDgSRZ01rOh4Uj1lMR2A4R2q+GtJF9g5CW2dpnb+;
Message-ID: <46C09DA6.3020700@simon.arlott.org.uk>
Date: Mon, 13 Aug 2007 19:06:30 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: joe@perches.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [133/2many] MAINTAINERS - CONEXANT ACCESSRUNNER USB DRIVER
References: <46bff95e.3/UvsFLGAGauZhiR%joe@perches.com>
In-Reply-To: <46bff95e.3/UvsFLGAGauZhiR%joe@perches.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07 07:25, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 594881d..d0a436a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1287,6 +1287,7 @@ M:	cxacru@fire.lp0.eu
>  L:	accessrunner-general@lists.sourceforge.net
>  W:	http://accessrunner.sourceforge.net/
>  S:	Maintained
> +F:	drivers/usb/atm/cxacru.c
>  
>  CORETEMP HARDWARE MONITORING DRIVER
>  P:	Rudolf Marek

NAK: Strange patch title "[133/2many] ...."

See Documentation/SubmittingPatches sections 1.2, 1.3, 1.5, 1.6, 3:
	http://marc.info/?l=linux-kernel&m=112112749912944&w=2
http://vger.kernel.org/z/zmailer-rrd-vger_SNMP_SYS_Load-Avg-5-min-G.html
http://vger.kernel.org/z/zmailer-rrd-vger_SNMP_SYS_SpoolUsedSpace-kB-G.html

-- 
Simon Arlott
