Return-Path: <linux-kernel-owner+w=401wt.eu-S1763901AbZAOLUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763901AbZAOLUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZAOLUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:20:05 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:45643 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZAOLUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:20:04 -0500
Date: Thu, 15 Jan 2009 12:22:32 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: [GIT] MFD pull request (build failure fix)
Message-ID: <20090115112232.GA2794@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull from my MFD tree ? I have a build failure fix for
pcf50633 on several architectures.

The following changes since commit 5393f780277165f282a37ed82dd878159ec9dad5:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Balaji Rao (1):
      mfd: Remove non exported references from pcf50633

 drivers/mfd/pcf50633-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
