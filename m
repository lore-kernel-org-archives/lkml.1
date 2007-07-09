Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXGIQXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXGIQXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXGIQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbXGIQXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:02 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
Subject: [GFS2/DLM] Pre-pull Patch Posting
Date: Mon,  9 Jul 2007 17:02:06 +0100
Message-Id: <11839969822277-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the current set of patches from the GFS2/DLM -nmw git tree which
are pending inclusion in the current merge window. There are quite a
few mainly as I was a bit lazy in pushing some of the smaller bug fixes
before.

There are a couple of things in -mm which depend upon changes in the
current GFS2 tree, so my plan is to request a merge very shortly to
leave time for those other items to be merged later.

All the changes here only relate to GFS2 and/or DLM, there are no
changes which affect any of the core code. Most of the patches are
in fatc bug fixes and/or cleanups. The only "new" feature is GFS2 is
the nanosecond timestamps feature.

Steve.


