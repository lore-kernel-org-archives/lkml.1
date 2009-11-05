Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbZKEUjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbZKEUjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758494AbZKEUjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:39:44 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58636 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZKEUjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TxczhbnKkNAM9Y2TDzEqTwaDnGkgxI+uaY9RcKXOKxsiTnZcfecCEkE+doix55juVE
         0AvYSqVARD4w8J7YZnb9mX2U6kOjcY2ZEfzjO7RwJZSF65DZAGJbVNu2dkNSkBrOCnS+
         uZ+xz8vJsDaafNzio4b6EUp586q0fixztmTxQ=
Message-ID: <4AF33812.8080401@gmail.com>
Date: Thu, 05 Nov 2009 21:39:46 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 34/41] rt2x00: add support for different chipset interfaces
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/09 18:36, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: add support for different chipset interfaces
> 
> Enhance rt2x00 infrastructure by adding explicit information
> about used chipset interface to struct rt2x00_chip.
> 
> The new field will be used by rt2800 drivers for rt2800 library.
> 
> Also add commonly used rt2x00_intf_is_pci() and rt2x00_intf_is_usb()
> helpers to make code easier to read (noticed by Ivo van Doorn).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
