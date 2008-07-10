Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYGJG5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYGJG5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYGJG5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:57:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbYGJG5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:57:15 -0400
Date: Wed, 9 Jul 2008 23:51:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: <trivail@bre-cln-ukleine.digi.com>, <linux-kernel@vger.kernel.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] Fix name of Russell King in various comments
Message-Id: <20080709235131.9b28dd12.akpm@linux-foundation.org>
In-Reply-To: <1214832433-11893-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1214832433-11893-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 15:27:13 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:

> This patch was created by
> 
> 	git grep -E -l 'Rus(el|s?e)l King' | xargs -r -t perl -p -i -e 's/Rus(el|s?e)l King/Russell King/g'
> 
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com>
> ---
>  drivers/usb/host/ohci-au1xxx.c  |    2 +-
>  drivers/usb/host/ohci-lh7a404.c |    2 +-
>  drivers/usb/host/ohci-s3c2410.c |    2 +-
>  drivers/usb/host/ohci-sa1111.c  |    2 +-
>  include/asm-avr32/setup.h       |    2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-au1xxx.c b/drivers/usb/host/ohci-au1xxx.c
> index 1b9abdb..2ec3584 100644
> --- a/drivers/usb/host/ohci-au1xxx.c
> +++ b/drivers/usb/host/ohci-au1xxx.c
> @@ -8,7 +8,7 @@
>   * Bus Glue for AMD Alchemy Au1xxx
>   *
>   * Written by Christopher Hoover <ch@hpl.hp.com>
> - * Based on fragments of previous driver by Rusell King et al.
> + * Based on fragments of previous driver by Russell King et al.

Would the patch be smaller if we switched over to "Rusell" everywhere?

If so, we may as well do that.
