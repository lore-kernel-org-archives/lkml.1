Return-Path: <linux-kernel-owner+w=401wt.eu-S966784AbXJPWVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966784AbXJPWVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966244AbXJPWTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:19:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36743 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966667AbXJPWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=K23zpuA3L5VaNTpqs1uYf4g9TRLwZIgF21+ANBj+6xsm0+wWIILWxw9lY/tw6rZwzJld8rgUO7H9FNsDaT9JUpRACq8QfDaVvACs/oWItLYdKjKdOZnxCJcydBVwXOCH8jTjisLmQnt+HlsGbkqxJCsiyisGEofpgA3v4vI0PVw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH] Update libata driver for bf548 atapi controller against the 2.6.24 tree.
Date: Wed, 17 Oct 2007 00:24:21 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
References: <1192524207.11166.1.camel@sevens.analog.com>
In-Reply-To: <1192524207.11166.1.camel@sevens.analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170024.22103.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007, Sonic Zhang wrote:
> Changes:
> 1. Remove irq_ack() and port_disable() methods
> 2. Acocomodate for the libata-link patches
> 3. Change Kconfig ATAPI mode option into a module param.
> 4. Add supported WMDMA mode.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

thanks, looks good

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
