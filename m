Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0BVTfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:35:50 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:54649 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0BVTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SelnHh++7QZ88vNGMj+u8JJjJGBeZLBtt66yx11k4z+WHpJribDIPErwmThCEgXPh/
         XBPZhb2p6oEDCnY3J+PNrGCz79wCsJpbj3IZvvsfeUsvpU7FsAPlFTRrKpKDJvdUaj+J
         ntHKRN+3T2qsLqvTZ89sBU2ghpLkTOTrVWThM=
MIME-Version: 1.0
In-Reply-To: <20100221001851.673db863@neptune.home>
References: <20100221001049.2f63f5d6@neptune.home> <20100221001851.673db863@neptune.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 22 Feb 2010 14:35:27 -0500
Message-ID: <8bd0f97a1002221135n6c52a657i1817063d2664bfda@mail.gmail.com>
Subject: Re: [PATCH 2/3] backlight: mark struct backlight_ops const
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       dri-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       acpi4asus-user@lists.sourceforge.net,
       ibm-acpi-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
       linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1MJaXmE021695

On Sat, Feb 20, 2010 at 18:18, Bruno PrÃ©mont wrote:> Â drivers/video/bf54x-lq043fb.c Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â  Â 2 +-> Â drivers/video/bfin-t350mcqb-fb.c Â  Â  Â  Â  Â  Â  Â  Â | Â  Â 2 +-
Acked-by: Mike Frysinger <vapier@gentoo.org>-mikeÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
