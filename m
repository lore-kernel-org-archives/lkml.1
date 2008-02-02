Return-Path: <linux-kernel-owner+w=401wt.eu-S935652AbYBBXEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652AbYBBXEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934561AbYBBXCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:02:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35455 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934897AbYBBXCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:02:51 -0500
Message-Id: <20080202230111.346847183@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Sun, 03 Feb 2008 00:01:11 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/3] mm: bdi: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are incremental patches against the "export BDI attributes in
sysfs" patchset, addressing the issues identified at the last
submission:

  - the read-only attributes are only for debugging
  - more consistent naming needed in /sys/class/bdi
  - documentation problems

I've also done some testing, and fixed some bugs.  Including patches
in -mm can do wonders, even before the kernel containing them is
released :)

Let me know if you prefer a resubmission of the original series with
these changes folded in.

Thanks,
Miklos

--
