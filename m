Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYLLVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYLLVlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYLLVlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:41:12 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:15609 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbYLLVlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:41:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUBAEtoQklR8VSS/2dsb2JhbAAIz2OCfQ
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: mark linux-uvc-devel as subscribers only
Date: Fri, 12 Dec 2008 22:41:13 +0100
User-Agent: KMail/1.9.9
Cc: mchehab@infradead.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <1228910967-25548-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228910967-25548-1-git-send-email-jirislaby@gmail.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812122241.13266.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

thanks for the patch.

On Wednesday 10 December 2008, Jiri Slaby wrote:
> Posting to linux-uvc-devel is restricted to members.
> You can subscribe to the list at ...

https://lists.berlios.de/mailman/listinfo/linux-uvc-devel

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@skynet.be>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7de513..ec5a7c3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4571,7 +4571,7 @@ S:	Maintained
>  USB VIDEO CLASS
>  P:	Laurent Pinchart
>  M:	laurent.pinchart@skynet.be
> -L:	linux-uvc-devel@lists.berlios.de
> +L:	linux-uvc-devel@lists.berlios.de (subscribers-only)
>  L:	video4linux-list@redhat.com
>  W:	http://linux-uvc.berlios.de
>  S:	Maintained

Mauro, can you please apply this ?

Regards,

Laurent Pinchart
