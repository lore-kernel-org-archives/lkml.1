Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbXFNGdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbXFNGdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXFNGc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:32:58 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:61378 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750879AbXFNGc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:32:58 -0400
Date: Thu, 14 Jun 2007 08:33:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [PATCH] i2c-gpio: Make some internal functions static
Message-ID: <20070614083312.5ffcc992@hyperion.delvare>
In-Reply-To: <20070613131641.59cea221@dhcp-255-175.norway.atmel.com>
References: <20070613.005438.126760855.anemo@mba.ocn.ne.jp>
	<20070613131641.59cea221@dhcp-255-175.norway.atmel.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007 13:16:41 +0200, Haavard Skinnemoen wrote:
> On Wed, 13 Jun 2007 00:54:38 +0900 (JST)
> Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> 
> > i2c_gpio_getsda() and i2c_gpio_getscl() are only used in this file.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Ah, of course. Hopefully this is the last remaining sign that the
> driver started out as a quick hack :-)
> 
> Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Correct. Applied, thanks.

-- 
Jean Delvare
