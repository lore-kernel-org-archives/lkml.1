Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbXFUWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbXFUWDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbXFUWDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:03:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35805 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756954AbXFUWDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:03:13 -0400
Date: Thu, 21 Jun 2007 23:08:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?Wm9sdMOhbg==?= HUBERT <zoltan.hubert@zzaero.com>
Cc: linux-kernel@vger.kernel.org,
       =?UTF-8?B?Wm9sdMOhbg==?= HUBERT <zoltan.hubert@zzaero.com>
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070621230858.2a0b1369@the-village.bc.nu>
In-Reply-To: <200706212349.54983.zoltan.hubert@zzaero.com>
References: <200706212349.54983.zoltan.hubert@zzaero.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> and we all know this. The un-ending stable ABI argument 
> goes into this same direction.

We don't have a stable ABI argument. Linus and others have repeatedly
made this clear; Stable user space ABI is important (sysfs developers
please note 8)). Stable kernel ABI/API not going to happen.

> So I feel that a turning-point is coming where a really 
> really really (x 15) stable and reliable kernel is NEEDED.

Its incredibly hard to keep a stable kernel side API/ABI by just
backporting fixes. Fortunately you can pay vendors to do this for you and
provide support, or if you just want the bits run stuff like Centos

