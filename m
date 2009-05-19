Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZESUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZESUgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZESUgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:36:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:11093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZESUgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:36:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,217,1241420400"; 
   d="scan'208";a="413914331"
Date: Tue, 19 May 2009 22:38:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [GIT PULL] MFD fixes for 2.6.30
Message-ID: <20090519203846.GC25083@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a couple fixes for the MFD subsystem, could you please pull them in:

The following changes since commit 279e677faa775ad16e75c32e1bf4a37f8158bc61:
  Linus Torvalds (1):
        Merge branch 'fixes-for-linus' of git://git.monstr.eu/linux-2.6-microblaze

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Mark Brown (1):
      mfd: Keep a cache of WM8350 volatile values

Nelson Castillo (1):
      mfd: pcf50633: fix unsafe disable_irq()

 drivers/mfd/pcf50633-core.c |    2 +-
 drivers/mfd/wm8350-core.c   |    8 --------
 2 files changed, 1 insertions(+), 9 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
