Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZKTAaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZKTAaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZKTAaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:30:13 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55953 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757912AbZKTAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:30:11 -0500
Date: Fri, 20 Nov 2009 00:29:43 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL] please pull bjdooks' i2c-pnx-fixes branch
Message-ID: <20091120002943.GA19796@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 648f4e3e50c4793d9dbf9a09afa193631f76fa26:
  Linus Torvalds (1):
        Linux 2.6.32-rc8

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux i2c-pnx-fixes

Kevin Wells (3):
      i2c: i2c-pnx: Limit minimum jiffie timeout to 2
      i2c: i2c-pnx: Made buf type unsigned to prevent sign extension
      i2c: i2c-pnx: Added missing mach/i2c.h and linux/io.h header file includes

 drivers/i2c/busses/i2c-pnx.c |    5 +++++
 include/linux/i2c-pnx.h      |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
