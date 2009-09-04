Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZIDPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZIDPet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZIDPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:34:48 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:49628 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZIDPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:34:48 -0400
Date: Fri, 4 Sep 2009 17:34:50 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] Add poll_get_char and poll_put_char uart_ops to
 atmel_serial.
Message-ID: <20090904153450.GH18963@pc-ras4041.res.insa>
References: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com>
 <20090727162312.35c2f9d4@hskinnemoen-d830>
 <20090727151900.GB4052@pc-ras4041.res.insa>
 <20090728180941.04441c00@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728180941.04441c00@hskinnemoen-d830>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 06:09:41PM +0200, Haavard Skinnemoen wrote :
> Albin Tonnerre wrote:
> > This patch allows using KGDB over the console with the atmel_serial
> > driver.
> > 
> > Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> 
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Nicolas, Andrew: Any news on this?

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
