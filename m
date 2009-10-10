Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZJJGFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZJJGFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZJJGFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:05:42 -0400
Received: from mail.perches.com ([173.55.12.10]:2043 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbZJJGFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:05:41 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH 0/3] MAINTAINERS: Add and support "K:" keyword
Date: Fri,  9 Oct 2009 23:05:01 -0700
Message-Id: <cover.1255153863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K: is a regex that's used to match content in a patch and
add entries from a MAINTAINERS section

Joe Perches (3):
  scripts/get_maintainer.pl: Add patch/file search for keywords
  MAINTAINERS: Document new "K:" entry type
  MAINTAINERS: Add OPEN FIRMWARE DEVICE TREE section

 MAINTAINERS               |   76 ++++++++++++++++++++++++++------------------
 scripts/get_maintainer.pl |   37 ++++++++++++++++++++-
 2 files changed, 80 insertions(+), 33 deletions(-)

