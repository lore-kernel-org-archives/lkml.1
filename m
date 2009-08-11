Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbZHKLzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbZHKLzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZHKLzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:55:36 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:24963
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751927AbZHKLzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:55:04 -0400
Message-ID: <4A8107F3.3050301@panasas.com>
Date: Tue, 11 Aug 2009 08:56:03 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090722 Remi/fc10 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Benny Halevy <bhalevy@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
References: <1249947969.8895.94.camel@Joe-Laptop.home>
In-Reply-To: <1249947969.8895.94.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2009 05:56:06.0159 (UTC) FILETIME=[6A94E1F0:01CA1A48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 02:46 AM, Joe Perches wrote:
> Resend for Andrew Morton.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Benny Halevy <bhalevy@panasas.com>
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

Thanks Joe!

Do you want that I push it through my tree?
I will. It'll be in next tomorrow.

Boaz
