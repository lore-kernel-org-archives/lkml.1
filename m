Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGAQ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGAQ7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZGAQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:58:53 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35451 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZGAQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:58:52 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 12:58:52 EDT
Message-Id: <20090701112926.825088732@linux-mips.org>
User-Agent: quilt/0.47-1
Date: Wed, 01 Jul 2009 12:29:26 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-mips@linux-mips.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
       Florian Fainelli <florian@openwrt.org>
Subject: [patch 00/12] Add support for Broadcom BCM63xx SoCs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series which has been sitting in the linux-bcm63xx git
repository for quite a while.  I'm posting this series for it to receive
the necessary review - in particular the drivers have so far been
ignored virtually entirely.

  Ralf

