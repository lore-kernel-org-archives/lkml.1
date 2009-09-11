Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZIKLbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZIKLbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZIKLbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:31:15 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:34928 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZIKLbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:31:14 -0400
Date: Fri, 11 Sep 2009 13:31:11 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com
Subject: Re: [PATCH v2] Add poll_get_char and poll_put_char uart_ops to
 atmel_serial.
Message-ID: <20090911113111.GI8705@pc-ras4041.res.insa>
References: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
 <1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
 <20090908103003.7617ff58@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908103003.7617ff58@hskinnemoen-d830>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Sep 2009 10:30 +0200, Haavard Skinnemoen wrote :
> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
> > This patch allows using KGDB over the console with the atmel_serial
> > driver.
> > 
> > Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> 
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Thanks Haavard & Andrew for your Acked-by. Is there anything I need to do to get
this pushed to mainline?

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
