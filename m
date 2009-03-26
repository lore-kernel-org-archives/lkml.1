Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZCZOvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZCZOvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbZCZOv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:51:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12249 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZCZOvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:51:25 -0400
Date: Thu, 26 Mar 2009 15:51:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Oskar Schirmer <os@emlix.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Chris Zankel <chris@zankel.net>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] add pca9543 driver
Message-ID: <20090326155105.5dfbd898@hyperion.delvare>
In-Reply-To: <1238078818-25977-1-git-send-email-os@emlix.com>
References: <1238078818-25977-1-git-send-email-os@emlix.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 15:46:58 +0100, Oskar Schirmer wrote:
> support pca9543 i2c bus switch chip
> 
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> ---
>  drivers/i2c/chips/Kconfig   |    3 +
>  drivers/i2c/chips/Makefile  |    1 +

Please read the header of these two files carefully again.

>  drivers/i2c/chips/pca9543.c |  188 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 192 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/chips/pca9543.c
> (...)

-- 
Jean Delvare
