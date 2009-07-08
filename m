Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZGHMXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZGHMXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZGHMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:23:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46747 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZGHMXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:23:08 -0400
Date: Wed, 8 Jul 2009 14:23:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <19028.31088.400461.939917@samba.org>
Message-ID: <alpine.LSU.2.00.0907081421240.6724@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr> <19026.38137.63807.427511@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
 <19028.31088.400461.939917@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-07-08 12:48, tridge@samba.org wrote:
>
> - some vendors may decide not to use Linux, and switch to embedded
>   windows instead if we don't have a clearly supported way of
>   avoiding these patents in the Linux kernels.

I perceive that:
Linux is primarily about doing things the right way, not about making
the largest userbase (it is a welcomed side-effect though).
