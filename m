Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZGMU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZGMU4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbZGMU4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:56:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:42165 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756818AbZGMU4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:56:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+N/T18eZuNXRVHTjz0RhrJQHs+FAoCLrLyS+ytNl
	miMq/jsfwV9gY7
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] media/omap: adding __init/__exit macros to lcd_drivers
Date: Mon, 13 Jul 2009 22:56:16 +0200
User-Agent: KMail/1.9.9
Cc: imre.deak@nokia.com, linux-omap@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <200907031439.40456.PeterHuewe@gmx.de>
In-Reply-To: <200907031439.40456.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907132256.17036.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 03 Juli 2009 14:39:40 schrieb Peter Hüwe:
> From: Peter Huewe <peterhuewe@gmx.de>
>
> Trivial patch which adds the __init and __exit macros to the module_init /
> module_exit functions to several files in drivers/video/omap/
>
> linux version 2.6.31-rc1 - linus git tree
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Hi Jini,
any updates on this patch yet ? :)

Thanks,
Peter
