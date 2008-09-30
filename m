Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYI3ITg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYI3ITg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYI3ITX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:19:23 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:35715 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYI3ITW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:19:22 -0400
Date: Tue, 30 Sep 2008 10:19:18 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [GIT] MFD pull request
Message-ID: <20080930081917.GA4759@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

While preparing the merge window, I found a build failure due to some changes
in gpiolib.
Could you please pull ?

The following changes since commit 94aca1dac6f6d21f4b07e4864baf7768cabcc6e7:
  Linus Torvalds (1):
        Linux 2.6.27-rc8

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Samuel Ortiz (2):
      mfd: Fix Kconfig accroding to the new gpiolib symbols
      mfd: Fix asic3 compilation

 drivers/mfd/Kconfig |    4 ++--
 drivers/mfd/asic3.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
