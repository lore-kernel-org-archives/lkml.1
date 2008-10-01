Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYJAPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYJAPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYJAPpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:45:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50072 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYJAPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:45:38 -0400
Date: Wed, 1 Oct 2008 08:41:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Joe Perches <joe@perches.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-K?nig <ukleinek@strlen.de>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-Id: <20081001084139.41e1956d.randy.dunlap@oracle.com>
In-Reply-To: <20081001133607.GA3714@elf.ucw.cz>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
	<20080922081239.GA28726@strlen.de>
	<20080922091256.GH1916@fluff.org.uk>
	<84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
	<48D7CA62.1020805@zytor.com>
	<20080929175625.GA3676@ucw.cz>
	<20080930171058.9e5f48d0.rdunlap@xenotime.net>
	<1222819790.29215.126.camel@localhost>
	<20080930173512.c221ade7.rdunlap@xenotime.net>
	<20081001133607.GA3714@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 15:36:08 +0200 Pavel Machek wrote:

> ...shall we add rule that subsystems will have "subsystem" in the name
> so that search does not list all the drivers, first?

We don't have a good track record with such rules, but I don't
mind trying that.

> Signed-off-by: Pavel Machek <pavel@suse.cz>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3596d17..7345707 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3825,7 +3825,7 @@ L:	linux-kernel@vger.kernel.org
>  W:	http://tifmxx.berlios.de/
>  S:	Maintained
>  
> -SOUND
> +SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)
>  P:	Jaroslav Kysela
>  M:	perex@perex.cz
>  L:	alsa-devel@alsa-project.org (subscribers-only)
> @@ -3855,7 +3855,7 @@ L:	cbe-oss-dev@ozlabs.org
>  W:	http://www.ibm.com/developerworks/power/cell/
>  S:	Supported
>  
> -STABLE BRANCH:
> +STABLE BRANCH
>  P:	Greg Kroah-Hartman
>  M:	greg@kroah.com
>  P:	Chris Wright


I see that a few more items need their trailing ':' removed:
DISKQUOTA:
IP MASQUERADING:
IPATH DRIVER:
SUSPEND TO RAM:


Thanks.
---
~Randy
