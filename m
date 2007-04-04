Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXDDR4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXDDR4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXDDR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:56:06 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:36989 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXDDR4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:56:04 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/90] Post 2.6.21 OMAP update
Date: Wed,  4 Apr 2007 13:46:27 -0400
Message-Id: <11757088774110-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: omap-2007-04-04-133556
References: omap-2007-04-04-133556
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Attached is a rather large OMAP update for post 2.6.21.

OMAP is a series of ARM processors from Texas Instruments
used in various cell phones and PDAs.

The patch series is based on code that has been brewing
in the linux-omap tree since last fall.

We'd like to switch the linux-omap tree to use the mainline
tree for core omap stuff, and this series attemps to do it
for most part. 

As the patch series is big, Andrew Morton asked me to post
it to LKML instead of linux-arm-kernel list for a wider review,
so please comment on the patches if you have a chance!

The patches touch only omap specific code at:

arch/arm/Kconfig
arch/arm/plat-omap
arch/arm/mach-omap1
arch/arm/mach-omap2
include/asm-arm/arch-omap

Regards,

Tony


