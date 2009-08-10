Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZHJVSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZHJVSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZHJVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:18:12 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:12803
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753247AbZHJVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:18:11 -0400
Message-ID: <4A808E93.9040406@panasas.com>
Date: Tue, 11 Aug 2009 00:18:11 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
References: <1249929631.8895.47.camel@Joe-Laptop.home>
In-Reply-To: <1249929631.8895.47.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 21:18:12.0932 (UTC) FILETIME=[117EB840:01CA1A00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug. 10, 2009, 21:40 +0300, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

(obvious) Ack

Thanks!

Benny

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b1114cf..50f25e3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3796,7 +3796,7 @@ W:	http://open-osd.org
>  T:	git git://git.open-osd.org/open-osd.git
>  S:	Maintained
>  F:	drivers/scsi/osd/
> -F:	drivers/include/scsi/osd_*
> +F:	include/scsi/osd_*
>  F:	fs/exofs/
>  
>  P54 WIRELESS DRIVER
> 
> 
