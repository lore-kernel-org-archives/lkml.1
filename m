Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZIJK3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZIJK3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZIJK3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZIJK3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Thu, 10 Sep 2009 12:27:52 +0100
Message-Id: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As merge time is approaching, here is the current content of the
GFS2 -nmw git tree. I'm not expecting to take any more patches
now for the current merge window unless any last minute bugs
are discovered.

There is not a huge amount new this time. Some extra context for
uevent messages, better error handling during block allocation,
and a clean up of extended attribute support. There is still more
to do on the extended attribute side of things, but this is a good
start I think.

There are a few bug fixes as well. Once these patches are merged
I'm intending to start off the next -nmw tree with a patch to
remove some of the (now unused) sysfs files as per the message
on cluster-devel a few weeks back.

Steve.

