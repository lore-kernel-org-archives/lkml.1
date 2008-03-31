Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYCaPmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYCaPmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYCaPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:41:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59235 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751469AbYCaPl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:41:56 -0400
Message-Id: <20080331154154.549122000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 31 Mar 2008 08:41:54 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] numa: add function for node_to_cpumask_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a small change to add the definition for a generic node_to_cpumask_ptr.
It isn't used in this patch, but allows other architectures to compile cleanly with
future changes coming to common kernel code.

Based on 2.6.25-rc5-mm1

Signed-off-by: Mike Travis <travis@sgi.com>

-- 
