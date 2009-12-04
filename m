Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZLDL6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZLDL6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZLDL6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:58:34 -0500
Received: from bamako.nerim.net ([62.4.17.28]:49215 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbZLDL6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:58:33 -0500
Date: Fri, 4 Dec 2009 12:58:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Colin Leroy <colin@colino.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x is unmaintained
Message-ID: <20091204125837.24880a63@hyperion.delvare>
In-Reply-To: <20091204121441.08cccb35@paperstreet.colino.net>
References: <20091204121441.08cccb35@paperstreet.colino.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 12:14:41 +0100, Colin Leroy wrote:
> Hi,
> 
> I don't have the hardware to maintain the ADT746X fan driver anymore.
> Here's a patch to update the status of the driver.
> 
> Signed-off-by: Colin Leroy <colin@colino.net>

Acked-by: Jean Delvare <khali@linux-fr.org>

> --- a/MAINTAINERS	2009-12-04 12:09:59.000000000 +0100
> +++ b/MAINTAINERS	2009-12-04 12:10:00.000000000 +0100
> @@ -322,11 +322,6 @@ T:	git git://git.kernel.org/pub/scm/linu
>  S:	Maintained
>  F:	drivers/net/wireless/adm8211.*
>  
> -ADT746X FAN DRIVER
> -M:	Colin Leroy <colin@colino.net>
> -S:	Maintained
> -F:	drivers/macintosh/therm_adt746x.c
> -
>  ADVANSYS SCSI DRIVER
>  M:	Matthew Wilcox <matthew@wil.cx>
>  L:	linux-scsi@vger.kernel.org
> 


-- 
Jean Delvare
