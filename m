Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZF1WCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZF1WCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZF1WCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:02:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33996 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZF1WCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:02:04 -0400
Date: Mon, 29 Jun 2009 00:02:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jamie Lokier <jamie@shareable.org>
cc: tridge@samba.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090628215754.GA29896@shareable.org>
Message-ID: <alpine.LSU.2.00.0906290000360.9212@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr> <19014.56477.311713.975403@samba.org> <20090628215754.GA29896@shareable.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-06-28 23:57, Jamie Lokier wrote:
>For those of us who don't want to omit the code, because we like
>compatibility and we're not in affected countries, or for research, it
>would be useful to have it as a mount option.
>
>So there should be these compile-time options:
>    2. CONFIG_VFAT_FS_DUALNAMES enabled: Create shortnames, unless
>       mount option "dualnames=no" is given, in which case that mount
>       behaves as if CONFIG_VFAT_FS_DUALNAMES is disabled.

If you are not in an affected country, why would you even want
to disable dualnames? [ on a per-mount basis...]

