Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbXGBNzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbXGBNzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbXGBNzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:55:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37734 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbXGBNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:55:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 2 Jul 2007 15:54:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ping: [GIT PULL] ieee1394 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.c55f5a5f5f6f4b57@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jun, Stefan Richter wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following updates.
> 
> Stefan Richter (2):
>       firewire: fix async reception on big endian machines
>       firewire: add Kconfig help on building both stacks
> 
> 
>  drivers/firewire/Kconfig   |   65 +++++++++++++++++++++++------------
>  drivers/firewire/fw-ohci.c |    6 ++--
>  2 files changed, 46 insertions(+), 25 deletions(-)

Linus, this fixes a show-stopping bug on big endian CPUs.  Thanks,
-- 
Stefan Richter
-=====-=-=== -=== ---=-
http://arcgraph.de/sr/

