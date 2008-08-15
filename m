Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYHOP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYHOP60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbYHOP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:58:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbYHOP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:58:16 -0400
Subject: [ANNOUNCE] linux-firmware.git repository.
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 15 Aug 2008 16:58:13 +0100
Message-Id: <1218815893.3184.107.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have created a git repository containing firmware files for use with
the Linux kernel. There is a daily script¹ which extracts the contents
of the firmware/ directory from the kernel itself, which is what has
seeded the repository:

 git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
 http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=shortlog

We are also able to include other firmware files from vendors who have
chosen not to contribute their firmware to be distributed as part of the
GPL'd kernel source tree, but would still like their firmware to be
readily available to Linux users.

Contributions of such firmware are welcome, and some are already in the
works...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

¹ http://git.kernel.org/?p=linux/kernel/git/dwmw2/misc-git-hacks.git;a=blob;f=extract-firmware-git.sh;hb=HEAD

