Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbXFMLSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbXFMLSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXFMLS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:18:27 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:59262 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757277AbXFMLS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:18:26 -0400
Date: Wed, 13 Jun 2007 13:16:41 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH] i2c-gpio: Make some internal functions static
Message-ID: <20070613131641.59cea221@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070613.005438.126760855.anemo@mba.ocn.ne.jp>
References: <20070613.005438.126760855.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007 00:54:38 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> i2c_gpio_getsda() and i2c_gpio_getscl() are only used in this file.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Ah, of course. Hopefully this is the last remaining sign that the
driver started out as a quick hack :-)

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
