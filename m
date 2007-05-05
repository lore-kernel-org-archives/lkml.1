Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbXEEXBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbXEEXBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934100AbXEEXBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:01:55 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54798 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934078AbXEEXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:01:53 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] [TRIVIAL] Small cleanups for do_path_lookup
Date: Sat,  5 May 2007 18:59:38 -0400
Message-Id: <1178405980972-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following 2 patches are trivial cleanups to do_path_lookup in namei.c.
Since these changes are trivial, they can go into 2.6.22-rc1 without any
problems.

Josef 'Jeff' Sipek (2):
      fs: Fix indentation in do_path_lookup
      fs: Use path_walk in do_path_lookup

diffstat for good measure:

 fs/namei.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Josef 'Jeff' Sipek.

jsipek@cs.sunysb.edu


