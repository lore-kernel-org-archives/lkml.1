Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXHVLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXHVLQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXHVLQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 07:16:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49947 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbXHVLQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 07:16:07 -0400
Date: Wed, 22 Aug 2007 12:23:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: =?UTF-8?B?Sm9zw6k=?= Luis =?UTF-8?B?UGF0acOxbyBBbmRyw6lz?= 
	<jopan@alumni.uv.es>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
Message-ID: <20070822122359.7ce8ddaa@the-village.bc.nu>
In-Reply-To: <46CBA0F0.70503@gmail.com>
References: <200708212149.12912.jopan@alumni.uv.es>
	<46CB626F.8020801@gmail.com>
	<200708220339.45138.jopan@alumni.uv.es>
	<46CBA0F0.70503@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The old SATA driver available from the IDE menu also does not support your 
> chip, so I don't believe there are any workarounds -- you'll need the issue 
> fixed.

What issue ?

>From the report its quite simple - enable the correct CONFIG_ATA based
drivers and it should all work fine.
