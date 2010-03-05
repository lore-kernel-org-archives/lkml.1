Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0CEJ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:57:23 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52826 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab0CEJ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:57:21 -0500
Date: Fri, 5 Mar 2010 10:57:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Amerigo Wang <amwang@redhat.com>, lm-sensors@lm-sensors.org
Subject: Re: [Patch] hwmon: remove the deprecated adt7473 driver
Message-ID: <20100305105718.4a680b3c@hyperion.delvare>
In-Reply-To: <20100305082008.5273.22938.sendpatchset@localhost.localdomain>
References: <20100305082008.5273.22938.sendpatchset@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010 03:16:33 -0500, Amerigo Wang wrote:
> 
> adt7473 driver is obsoleted by adt7475 driver. And it is scheduled
> to be removed in Feb 2010.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 0349790..8debdd6 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -449,12 +449,6 @@ Who:	Alok N Kataria <akataria@vmware.com>
>  
>  ----------------------------
>  
> -What:	adt7473 hardware monitoring driver
> -When:	February 2010
> -Why:	Obsoleted by the adt7475 driver.
> -Who:	Jean Delvare <khali@linux-fr.org>
> -
> ----------------------------
> (...)

Applied, thanks.

-- 
Jean Delvare
