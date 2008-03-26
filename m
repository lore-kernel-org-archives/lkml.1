Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbYCZVZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbYCZVZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762334AbYCZVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:23:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51906 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762283AbYCZVXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:23:48 -0400
Message-Id: <20080326212347.466221000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 14:23:47 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] generic: simplify setup_nr_cpu_ids and add set_cpus_allowed_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two simple patches to simplify setup_nr_cpu_ids and add a new function,
set_cpus_allowed_ptr().

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git


Signed-off-by: Mike Travis <travis@sgi.com>

-- 
