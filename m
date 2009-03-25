Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbZCYLkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbZCYLkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbZCYLiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088AbZCYLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:48 -0400
Message-Id: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/6] perf_counter: new output ABI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch-set extends the perf_counter output ABI and updates
kerneltop accordingly.


