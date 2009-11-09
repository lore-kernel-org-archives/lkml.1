Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZKIQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZKIQcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZKIQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:32:30 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42755 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZKIQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=khEN6fPSy7GoRUyFP/TbBfEJXamM3Fvjl5tFMKF7o7DxZZbA0xY466afGVIUZBsT1K
         LvWI0gY/5S4gQdrqJisWWF0DRZoXnoOu1+O6lk2Ute1Uvd4mxyzREc5q2LASoiaLz4V0
         CcxM7/TlF8s890IX4q2srlsgvan/HFeuUVdbk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Staging: update TODO files
Date: Mon, 9 Nov 2009 17:15:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <200910211442.11785.bzolnier@gmail.com>
In-Reply-To: <200910211442.11785.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911091715.49814.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 October 2009 14:42:11 Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] Staging: update TODO files
> 
> Remove my mail address.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

ping.  Could you please apply it?

> ---
>  drivers/staging/rtl8187se/TODO |    3 +--
>  drivers/staging/rtl8192su/TODO |    3 +--
>  drivers/staging/vt6655/TODO    |    5 ++---
>  drivers/staging/vt6656/TODO    |    5 ++---
>  4 files changed, 6 insertions(+), 10 deletions(-)
> 
> Index: b/drivers/staging/rtl8187se/TODO
> ===================================================================
> --- a/drivers/staging/rtl8187se/TODO
> +++ b/drivers/staging/rtl8187se/TODO
> @@ -11,5 +11,4 @@ TODO:
>  - sparse fixes
>  - integrate with drivers/net/wireless/rtl818x
>  
> -Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
> -Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>.
> +Please send any patches to Greg Kroah-Hartman <greg@kroah.com>.
> Index: b/drivers/staging/rtl8192su/TODO
> ===================================================================
> --- a/drivers/staging/rtl8192su/TODO
> +++ b/drivers/staging/rtl8192su/TODO
> @@ -14,5 +14,4 @@ TODO:
>  - sparse fixes
>  - integrate with drivers/net/wireless/rtl818x
>  
> -Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
> -Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>.
> +Please send any patches to Greg Kroah-Hartman <greg@kroah.com>.
> Index: b/drivers/staging/vt6655/TODO
> ===================================================================
> --- a/drivers/staging/vt6655/TODO
> +++ b/drivers/staging/vt6655/TODO
> @@ -16,6 +16,5 @@ TODO:
>  - sparse fixes
>  - integrate with drivers/net/wireless
>  
> -Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
> -Forest Bond <forest@alittletooquiet.net> and Bartlomiej Zolnierkiewicz
> -<bzolnier@gmail.com>.
> +Please send any patches to Greg Kroah-Hartman <greg@kroah.com>
> +and Forest Bond <forest@alittletooquiet.net>.
> Index: b/drivers/staging/vt6656/TODO
> ===================================================================
> --- a/drivers/staging/vt6656/TODO
> +++ b/drivers/staging/vt6656/TODO
> @@ -15,6 +15,5 @@ TODO:
>  - sparse fixes
>  - integrate with drivers/net/wireless
>  
> -Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
> -Forest Bond <forest@alittletooquiet.net> and Bartlomiej Zolnierkiewicz
> -<bzolnier@gmail.com>.
> +Please send any patches to Greg Kroah-Hartman <greg@kroah.com>
> +and Forest Bond <forest@alittletooquiet.net>.
