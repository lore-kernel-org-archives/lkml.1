Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXIQSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXIQSml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbXIQSmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:42:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46958 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbXIQSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:42:19 -0400
Date: Mon, 17 Sep 2007 20:42:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Avi Kivity <avi@qumranet.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rc] KVM: Fix virtualization menu help text
In-Reply-To: <11900202451420-git-send-email-avi@qumranet.com>
Message-ID: <Pine.LNX.4.64.0709172041270.21412@fbirervta.pbzchgretzou.qr>
References: <11900202451420-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 17 2007 11:10, Avi Kivity wrote:
>
>What guest drivers?

Well, why is lguest called lguest? :)

But yeah, ack.

>Cc: Jan Engelhardt <jengelh@computergmbh.de>
>Signed-off-by: Avi Kivity <avi@qumranet.com>
>---
>diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
>index 9b72f33..8749fa4 100644
>--- a/drivers/kvm/Kconfig
>+++ b/drivers/kvm/Kconfig
>@@ -6,7 +6,8 @@ menuconfig VIRTUALIZATION
> 	depends on X86
> 	default y
> 	---help---
>-	  Say Y here to get to see options for virtualization guest drivers.
>+	  Say Y here to get to see options for using your Linux host to run other
>+	  operating systems inside virtual machines (guests).
> 	  This option alone does not add any kernel code.
> 
> 	  If you say N, all options in this submenu will be skipped and disabled.
>-- 
