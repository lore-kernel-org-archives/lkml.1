Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZKESmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZKESmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZKESmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:42:01 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53580 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbZKESl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=iVXyMZ9tCocP2nTgriqz6/iwz3Z9yMun/nDcBQ3fN03Ph+jj5Rfkp/7a9EgM2VM5CN
         Ozb1cYXvQ4DRQ2HOk2IRq4b8aq7QFIjXTQDzB+2fTC6ReyJuA7nWQq8INB91jTVnuN6x
         UJmkoFuO7F+BBM4IuSeXwbmELRtWj+5zDdft0=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 07/41] rt2x00: fix rt2x00usb_register_read() comment
Date: Thu, 5 Nov 2009 19:42:02 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051942.03123.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00usb_register_read() comment
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2x00usb.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
> @@ -232,7 +232,7 @@ static inline int rt2x00usb_eeprom_read(
>  }
>  
>  /**
> - * rt2x00usb_regbusy_read - Read 32bit register word
> + * rt2x00usb_register_read - Read 32bit register word
>   * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
>   * @offset: Register offset
>   * @value: Pointer to where register contents should be stored
> 


