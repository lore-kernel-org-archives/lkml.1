Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502Ab0A2Ukv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0A2Ukv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241Ab0A2Ujg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:39:36 -0500
Received: from mga05.intel.com ([192.55.52.89]:42801 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754917Ab0A2Uje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,370,1262592000"; 
   d="scan'208";a="535880012"
Date: Fri, 29 Jan 2010 21:41:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Artamonow <mad_soft@inbox.ru>
Subject: [GIT] [2.6.33] MFD pull request
Message-ID: <20100129204100.GA29150@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have one remaining mfd fix for 2.6.33, that slipped through my last pull
request. It's an asic3 build failure, thanks in advance for pulling.

The following changes since commit 499a2673713c85734a54c37dd90b4b729de399c4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Dmitry Artamonow (1):
      mfd: Fix asic3 build

 drivers/mfd/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
