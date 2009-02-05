Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZBESMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZBESMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZBESMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:12:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3201 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZBESMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:12:45 -0500
Date: Thu, 5 Feb 2009 18:12:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20090205181235.GA4851@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: The worst is enemy of the bad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 0/2] WM8350 updates
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw you had applied most of the outstanding patches for the WM8350
except for these two so I figured they may have been lost in the shuffle
and am resending them:

The following changes since commit e3d31e08fa03bb896ddea609dc5a703cf072babc:
  Mark Brown (1):
        mfd: Use bulk read to fill WM8350 register cache

are available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-sameo

Mark Brown (2):
      mfd: Support active high IRQs on WM835x
      mfd: Ensure all WM8350 IRQs are masked at startup

 drivers/mfd/wm8350-core.c       |   23 ++++++++++++++++++++++-
 include/linux/mfd/wm8350/core.h |    2 ++
 2 files changed, 24 insertions(+), 1 deletions(-)
