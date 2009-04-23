Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZDWKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZDWKWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZDWKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:22:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44431 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZDWKWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:22:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Block alloc fixes
Date: Thu, 23 Apr 2009 10:16:53 +0100
Message-Id: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches fix a couple of bugs in the block allocation
code that was updated at the merge window. Thanks are due to
Benny Halevy, Christoph Lameter and Willy Tarreau for looking
at the __ffs64 patch. I've updated the comment in that patch
in the light of Willy Tarreau's suggestion,

Steve.


