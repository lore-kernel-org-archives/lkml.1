Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXFTJpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXFTJpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbXFTJpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:45:06 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:57735 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754793AbXFTJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:45:05 -0400
Date: Wed, 20 Jun 2007 11:45:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: TSL2550 support.
Message-ID: <20070620114558.499cc9be@hyperion.delvare>
In-Reply-To: <20070619144730.GA20624@enneenne.com>
References: <20070619153940.0e120fb0@hyperion.delvare>
	<20070619144730.GA20624@enneenne.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,

On Tue, 19 Jun 2007 16:47:30 +0200, Rodolfo Giometti wrote:
> Add support for Taos TSL2550 ambient light sensors.
> (http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  drivers/i2c/chips/Kconfig   |   10 +
>  drivers/i2c/chips/Makefile  |    1 +
>  drivers/i2c/chips/tsl2550.c |  453 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 464 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/chips/tsl2550.c

Patch applied, thank you.

-- 
Jean Delvare
