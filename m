Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0BVXrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:47:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47106
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab0BVXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:47:53 -0500
Date: Mon, 22 Feb 2010 15:48:11 -0800 (PST)
Message-Id: <20100222.154811.175887702.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, keil@b1-systems.de, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: fix a few Kconfig imperfections
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100222210938.75A3B4011D@xenon.ts.pxnet.com>
References: <20100222210938.75A3B4011D@xenon.ts.pxnet.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Mon, 22 Feb 2010 22:09:38 +0100 (CET)

> 1. Rewrite the outdated help texts for config options ISDN and ISDN_CAPI.
> 2. The MISDN config option appeared between ISDN_I4L and the I4L hardware
>    driver options; move it to a less irritating place.
> 3. HYSDN is not in fact an I4L driver, and needn't depend on ISDN_I4L, so
>    move it from the I4L section to the general section.
> 4. ISDN_HDLC is now also used by drivers outside I4L.  Move it from the
>    I4L section to the general section, too.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied.
