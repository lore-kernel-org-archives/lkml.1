Return-Path: <linux-kernel-owner+w=401wt.eu-S1763744AbYARSdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763744AbYARSdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbYARSaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:30:13 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39541 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764179AbYARSaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:30:11 -0500
Message-Id: <20080118183011.354965000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jan 2008 10:30:11 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: Reduce memory usage for large count NR_CPUs fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixup change NR_CPUS patchset by rebasing on 2.6.24-rc8-mm1
from 2.6.24-rc6-mm1) and adding changes suggested by reviews.

Additionally, some new config options have been added to enable
large SMP configurations.

Based on 2.6.24-rc8-mm1

Signed-off-by: Mike Travis <travis@sgi.com>
---

-- 
