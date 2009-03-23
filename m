Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbZCWRZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbZCWRZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbZCWRZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:25:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZCWRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:25:10 -0400
Message-Id: <20090323172205.389341032@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Mar 2009 18:22:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/7] perf_counter: syscall ABI cleanup and mmap() interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested on x86_64, compile tested for ppc64.

-- 

