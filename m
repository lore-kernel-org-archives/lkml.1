Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265Ab0AWMWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0AWMWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756Ab0AWMW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:22:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35991 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042Ab0AWMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:22:28 -0500
Date: Sat, 23 Jan 2010 12:24:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 31/31] CAPI: Officially claim char major 191
Message-ID: <20100123122430.5a078b4a@lxorguk.ukuu.org.uk>
In-Reply-To: <445e1bf881b6f8b6a5886d6eee70f6435a5619d6.1264201408.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
	<445e1bf881b6f8b6a5886d6eee70f6435a5619d6.1264201408.git.jan.kiszka@web.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 14:21:31 +0100
Jan Kiszka <jan.kiszka@web.de> wrote:

> I found no trace of this mysterious "pcl181" device, neither in-tree nor
> out there in the wild. At the same time, the in-tree CAPI middleware is
> using major 191 for many years now and obviously without any conflict.
> Let's officially claim this major number.

This is not the way it should have been done but whoever needs spanking
got away with it years ago. Given that this seems the best way forward.

With LANANA hat on

Acked-by: Alan Cox <alan@linux.intel.com>
