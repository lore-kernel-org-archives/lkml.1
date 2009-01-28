Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZA1X1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZA1X1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZA1X1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:27:09 -0500
Received: from kroah.org ([198.145.64.141]:56966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbZA1X1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:27:07 -0500
Date: Wed, 28 Jan 2009 15:25:43 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for your 2.6-git tree
Message-ID: <20090128232543.GA23030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 documentation bugfixes against your current kernel git tree.

All of these have been in the -next releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/DocBook/uio-howto.tmpl        |   88 +++++++++++++++++++++++++++
 Documentation/ja_JP/stable_kernel_rules.txt |   15 +++--
 drivers/base/core.c                         |    2 +-
 3 files changed, 99 insertions(+), 6 deletions(-)

---------------

Hans J. Koch (1):
      UIO: Add missing documentation of features added recently

Randy Dunlap (1):
      driver-core: fix kernel-doc parameter name

Tsugikazu Shibata (1):
      Sync patch for jp_JP/stable_kernel_rules.txt

