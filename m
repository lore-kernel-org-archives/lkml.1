Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbZLPRAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbZLPRAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762273AbZLPRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:00:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762282AbZLPRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:00:12 -0500
Message-Id: <20091216165553.802559834@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 17:55:53 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] perf per-task-per-cpu support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its not the most elegant solution, but it does seem to work.

