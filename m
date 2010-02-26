Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966186Ab0BZV2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:28:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:39575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966162Ab0BZV2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:28:14 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, michaelc@cs.wisc.edu, pjones@redhat.com
Subject: [GIT PULL IBFT] + Introduction
Date: Fri, 26 Feb 2010 21:27:07 +0000
Message-Id: <1267219629-31536-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 21:27:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

The following changes since commit 6ebdc661b608671e9ca572af8bb42d58108cc008:
 Linus Torvalds (1):
	Merge branch 'next-devicetree' of git://git.secretlab.ca/git/linux-2.6

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git ibft-fixes

There are two patches: one is a simple fix and the other adds me and Peter
as the maintainers of the iBFT driver. In the past the maintainer for the iBFT
was .. well nobody :-) Mike Christie and Greg KH were taking the patches but
both agreed that it didn't make sense for it to be in their git tree since it
wasn't per say in their baileywick.

Hence I am stepping up and becoming the maintainer for this driver.

Cheers,

Konrad

---
 MAINTAINERS                   |    6 ++++++
 drivers/firmware/iscsi_ibft.c |    8 +++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

