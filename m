Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYFSKAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYFSKAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYFSJ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:59:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:23090 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYFSJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I7XzGwkmGeZJB7uWPSWIWPazhLKwfh6iABgGj3S0A+y8FiY85D0TWov3ZKL5vTJB0N
         gREsC0d89wd6Q0qOU3Q3PzYqwiLlNlrGkQTS9CnhMPiVy+cczRk/S/fP7NraMwvf/Bva
         qi1w6S2/bwhKCHF67SUBm8clP5W2M9B0OfGpE=
Message-ID: <74d0deb30806190259l2ff7931fo819ededc7aec02f7@mail.gmail.com>
Date: Thu, 19 Jun 2008 11:59:50 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Samuel Ortiz" <sameo@openedhand.com>
Subject: Re: [PATCH] MFD maintainer
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ben Dooks" <ben-linux@fluff.org>, "Ian Molton" <spyro@f2s.com>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <20080618214223.GE22566@caravaggio>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618214223.GE22566@caravaggio>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Ian, Dmitry and Russell to Cc.

On Wed, Jun 18, 2008 at 11:42 PM, Samuel Ortiz <sameo@openedhand.com> wrote:
> Hi,
>
> We probably need someone to look after the few drivers/mfd patches coming
> every now and then. As agreed with Andrew, I'm ok to do so and my employer
> is fine with me spending a few working hours on it, if needed.

Right now quite some of the MFD patches go through arm-kernel, but I
guess once that initial rush of ARM machine patches depending on MFD
patches submitted at the same time is over, it's a very good idea to
have a proper path into the kernel.

regards
Philipp

> Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
> --
>
>  MAINTAINERS |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cd587ee..f45938b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2814,6 +2814,12 @@ W:       https://tango.0pointer.de/mailman/listinfo/s270-linux
>  W:     http://0pointer.de/lennart/tchibo.html
>  S:     Maintained
>
> +MULTIFUNCTION DEVICES (MFD)
> +P:     Samuel Ortiz
> +M:     sameo@openedhand.com
> +L:     linux-kernel@vger.kernel.org
> +S:     Supported
> +
>  MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
>  P:     Pierre Ossman
>  M:     drzeus-mmc@drzeus.cx
>
