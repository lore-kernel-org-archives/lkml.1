Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZBONcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZBONcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZBONcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:32:35 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:13384 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZBONce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:32:34 -0500
Date: Sun, 15 Feb 2009 14:32:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] MAINTAINERS: switch hdaps to Frank Seidel
Message-ID: <20090215143221.202160ae@hyperion.delvare>
In-Reply-To: <49980A67.7030403@suse.de>
References: <49980A67.7030403@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Sun, 15 Feb 2009 13:28:23 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> As Rovert Love doesn't any more seem to be realy
> active on hdaps driver i'll happily take it over.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  MAINTAINERS |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1905,10 +1905,10 @@ W:	http://gigaset307x.sourceforge.net/
>  S:	Maintained
>  
>  HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
> -P:	Robert Love
> -M:	rlove@rlove.org
> +P:	Frank Seidel
> +M:	frank@f-seidel.de
>  M:	linux-kernel@vger.kernel.org

I had never noticed this. Either hdaps is considered a hardware
monitoring driver and the list should be lm-sensors@lm-sensors.org, or
it's not and the driver should be moved to a different directory
(drivers/misc, drivers/mfd, whatever.)

> -W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
> +W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/

There doesn't appear to be anything hdaps-specific at this address, so
it's probably not worth mentioning.

>  S:	Maintained
>  
>  GSPCA FINEPIX SUBDRIVER


-- 
Jean Delvare
