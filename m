Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYGQRpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYGQRpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932147AbYGQRpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:45:22 -0400
Received: from isilmar.linta.de ([213.133.102.198]:40369 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932134AbYGQRpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:45:20 -0400
Date: Thu, 17 Jul 2008 19:42:48 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfixes for 2.6.27
Message-ID: <20080717174248.GA6802@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

There are a few PCMCIA bugfixes for 2.6.27 available at

        git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-fixes-2.6/

Please pull from that location. The diffstat and list of changes follows,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik

----
 drivers/char/pcmcia/cm4000_cs.c |    2 +-
 drivers/ide/legacy/ide-cs.c     |    2 --
 drivers/pcmcia/cistpl.c         |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)
----
Dominik Brodowski (1):
      pcmcia: fix return value in cm4000_cs.c

Larry Finger (1):
      pcmcia: ide-cs: Remove outdated comment

Marc Zyngier (1):
      pcmcia: fix cisinfo_t removal

