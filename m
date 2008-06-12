Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYFLAVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYFLAVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYFLAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:21:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:50015 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYFLAVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:21:09 -0400
Date: Wed, 11 Jun 2008 17:10:35 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches against 2.6.26-rc5
Message-ID: <20080612001035.GA7615@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two simple patches against your 2.6.26-git tree.

They both fix documentation errors, one in the kerneldoc portion of the
driver core, another is a typo in the kobject.txt documentation.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/kobject.txt |    2 +-
 drivers/base/core.c       |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

---------------

David Brigada (1):
      kobject: Documentation Spelling Patch

Randy Dunlap (1):
      dev_set_name: fix missing kernel-doc

