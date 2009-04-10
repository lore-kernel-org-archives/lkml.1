Return-Path: <linux-kernel-owner+w=401wt.eu-S936175AbZDJUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936175AbZDJUne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbZDJUnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:43:25 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4076 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZDJUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:43:24 -0400
Subject: [GIT PULL] MAINTAINERS - Add file patterns and script to parse them
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 13:41:27 -0700
Message-Id: <1239396087.12402.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now in a git repository.
Let me know if I stuffed it up.

Signed-off-by: Joe Perches <joe@perches.com> 

The following changes since commit d848223808c5d21e1b3cea090047e34722c6254b:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../dhowells/linux-2.6-mn10300

are available in the git repository at:

  git://repo.or.cz/linux-2.6/trivial-mods.git gm_20090410

Joe Perches (19):
      Add scripts/get_maintainer.pl
      MAINTAINERS - Add file patterns
      MAINTAINERS - Standardize style
      MAINTAINERS - Remove HP Fibre Channel HBA no longer in tree
      MAINTAINERS - standardize "T:       git urls"
      MAINTAINERS - Add Linus Torvalds' git
      MAINTAINERS - i2c_tiny_usb T: should be W:
      MAINTAINERS - Update FPU Emulator contact address and web page
      MAINTAINERS - Remove x86/Voyager no longer in tree
      MAINTAINERS - Remove cyblafb frame buffer no longer in tree
      MAINTAINERS - Coalesce sections "DVB" and "Video for Linux"
      MAINTAINERS - Update M68K patterns
      MAINTAINERS - Update DRIVER CORE patterns
      MAINTAINERS - Add missing "/" to some pattern directories
      MAINTAINERS - Add additional patterns
      MAINTAINERS - Update Freescale sound patterns
      scripts/get_maintainer.pl - Allow multiple files on command line
      MAINTAINERS - Update frv arch patterns
      MAINTAINERS - Update MN10300 patterns

 MAINTAINERS               | 1568 +++++++++++++++++++++++++++++++++++++++------
 scripts/get_maintainer.pl |  515 +++++++++++++++
 2 files changed, 1896 insertions(+), 187 deletions(-)
 create mode 100755 scripts/get_maintainer.pl


