Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbXCAIEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbXCAIEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbXCAIEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:04:44 -0500
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:2259 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932792AbXCAIEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:04:43 -0500
Date: Thu, 1 Mar 2007 09:02:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrea Arcangeli <andrea@suse.de>, philb@gnu.org, tim@cyberelk.net
Subject: Re: [patch 2.6.21-rc2] parport is an orphan
Message-Id: <20070301090249.87ebff38.khali@linux-fr.org>
In-Reply-To: <200702281514.21402.david-b@pacbell.net>
References: <200702281514.21402.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 15:14:20 -0800, David Brownell wrote:
> The writing on the wall seem to be that the parport stack is orphaned,
> rather than maintained by four folk ... and having a webpage that says
> the latest patches are based on a 2.5 kernel.

I share David's impression here. Andrew, can you please pick this patch?

> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Jean Delvare <khali@linux-fr.org>

> 
> Index: g26/MAINTAINERS
> ===================================================================
> --- g26.orig/MAINTAINERS	2007-02-28 12:46:00.000000000 -0800
> +++ g26/MAINTAINERS	2007-02-28 12:47:58.000000000 -0800
> @@ -2552,16 +2552,8 @@ L:	i2c@lm-sensors.org
>  S:	Maintained
>  
>  PARALLEL PORT SUPPORT
> -P:	Phil Blundell
> -M:	philb@gnu.org
> -P:	Tim Waugh
> -M:	tim@cyberelk.net
> -P:	David Campbell
> -P:	Andrea Arcangeli
> -M:	andrea@suse.de
>  L:	linux-parport@lists.infradead.org
> -W:	http://people.redhat.com/twaugh/parport/
> -S:	Maintained
> +S:	Orphan
>  
>  PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
>  P:	Tim Waugh


-- 
Jean Delvare
