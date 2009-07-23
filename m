Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZGWTVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZGWTVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZGWTVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:21:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZGWTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:08 -0400
Message-Id: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:42 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 00/13] current patch queue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch queue against:

git checkout -b tmp tip/master
git merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git merge git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git lockdep-bfs-rebase


