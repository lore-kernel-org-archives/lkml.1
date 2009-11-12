Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZKLO5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZKLO5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZKLO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:57:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZKLO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:57:06 -0500
Message-Id: <20091112145527.808885617@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 15:55:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] sched: select_task_rq_fair() cleanup/changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bits I came up with while trying to grok the recent changes in the
mentioned function.

Please have a careful look.


