Return-Path: <linux-kernel-owner+w=401wt.eu-S935770AbXGRSSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935770AbXGRSSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934388AbXGRSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:18:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60807 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934255AbXGRSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:18:04 -0400
Date: Wed, 18 Jul 2007 20:18:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use menuconfig objects - CONFIG_ISDN_I4L [v2]
In-Reply-To: <20070715131144.3467DFC040@xenon.ts.pxnet.com>
Message-ID: <Pine.LNX.4.64.0707182016180.5385@fbirervta.pbzchgretzou.qr>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707101107340.11053@fbirervta.pbzchgretzou.qr>
 <46980610.9080705@imap.cc> <Pine.LNX.4.64.0707141200310.25352@fbirervta.pbzchgretzou.qr>
 <20070715131144.3467DFC040@xenon.ts.pxnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Remove a menu statement and several dependencies from the Kconfig files in
>the drivers/isdn tree as they have become unnecessary by the transformation
>of CONFIG_ISDN from "menu, config" into "menuconfig".
>(Modified version of a patch originally proposed by Jan Engelhardt.)
>
>Signed-off-by: Tilman Schmidt <tilman@imap.cc>
>---
>
>This is my alternative proposal for
>use-menuconfig-objects-isdn-config_isdn_i4l.patch (patch 2 of 6 in Jan's
>"Use menuconfig objects 4 - ISDN" series). It must go between patch 1 and
>3 of that series because they touch some of the same files.

This looks good to me. (Applies on top of today's git.)


Thanks,
	Jan
-- 
