Return-Path: <linux-kernel-owner+w=401wt.eu-S974264AbXHMSjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974264AbXHMSjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032992AbXHMSTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:19:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032956AbXHMSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:19:10 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO
	FOR LINUX
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: joe@perches.com
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 13 Aug 2007 15:15:10 -0300
Message-Id: <1187028910.664.11.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Dom, 2007-08-12 às 23:39 -0700, joe@perches.com escreveu:
> Add file pattern to MAINTAINER entry

> @@ -5046,6 +5046,10 @@ L:	video4linux-list@redhat.com
> +F:	Documentation/video4linux/
> +F:	drivers/media/
> +F:	include/linux/videodev2.h
> +F:	include/media/

There are more include files to be added, for the older V4L APIs:
F: include/linux/video_decoder.h
F: include/linux/videodev.h

Cheers,
Mauro

