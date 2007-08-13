Return-Path: <linux-kernel-owner+w=401wt.eu-S943068AbXHMSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943068AbXHMSr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971572AbXHMSeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:34:12 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2497 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S974249AbXHMSdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:33:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO FOR LINUX
Date: Mon, 13 Aug 2007 20:32:51 +0200
User-Agent: KMail/1.9.7
Cc: joe@perches.com, video4linux-list@redhat.com,
       torvalds@linux-foundation.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
In-Reply-To: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132032.51610.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 08:39:28 joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e962b1..25bc39a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5046,6 +5046,10 @@ L:	video4linux-list@redhat.com
>  W:	http://linuxtv.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
>  S:	Maintained
> +F:	Documentation/video4linux/
> +F:	drivers/media/
> +F:	include/linux/videodev2.h
> +F:	include/media/
>
>  VT1211 HARDWARE MONITOR DRIVER
>  P:	Juerg Haefliger
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer

While we're at it: I noticed that there was no entry for the ivtv driver 
(part of the kernel since 2.6.22). So here it is:

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

--- MAINTAINERS.org     2007-08-13 20:23:47.000000000 +0200
+++ MAINTAINERS 2007-08-13 20:28:17.000000000 +0200
@@ -2036,6 +2036,17 @@
 W:     http://www.melware.de
 S:     Maintained

+IVTV VIDEO4LINUX DRIVER
+P:     Hans Verkuil
+M:     hverkuil@xs4all.nl
+L:     ivtv-devel@ivtvdriver.org
+L:     ivtv-users@ivtvdriver.org
+L:     video4linux-list@redhat.com
+W:     http://www.ivtvdriver.org
+S:     Maintained
+F:     Documentation/video4linux/README.ivtv
+F:     drivers/media/video/ivtv/
+
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:     David Woodhouse
 M:     dwmw2@infradead.org
