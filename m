Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab0CAPeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:34:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0CAPeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:34:13 -0500
Message-ID: <4B8BDE34.3070900@redhat.com>
Date: Mon, 01 Mar 2010 10:33:08 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0b2pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com, michaelc@cs.wisc.edu
Subject: Re: [PATCH 2/2] ibft: Update MAINTAINERS file.
References: <1267219629-31536-1-git-send-email-konrad@kernel.org> <1267219629-31536-3-git-send-email-konrad@kernel.org>
In-Reply-To: <1267219629-31536-3-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 04:27 PM, Konrad Rzeszutek Wilk wrote:
> Provide the right e-mail and names for me and Peter.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>

Signed-off-by: Peter Jones <pjones@redhat.com>

> ---
>  MAINTAINERS |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 317ed38..0d8a948 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2399,6 +2399,12 @@ L:	virtualization@lists.linux-foundation.org
>  S:	Maintained
>  F:	drivers/char/virtio_console.c
>  
> +iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
> +M:	Peter Jones <pjones@redhat.com>
> +M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
> +S:	Maintained
> +F:	drivers/firmware/iscsi_ibft*
> +
>  GSPCA FINEPIX SUBDRIVER
>  M:	Frank Zago <frank@zago.net>
>  L:	linux-media@vger.kernel.org


-- 
        Peter

First things first -- but not necessarily in that order.
		-- The Doctor
