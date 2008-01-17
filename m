Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYAQWiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYAQWiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbYAQWfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:35:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47404 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759384AbYAQWfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:35:47 -0500
Message-Id: <20080117223546.419383000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jan 2008 14:35:46 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: Reduce memory and intra-node effects with large count NR_CPUs fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixup change NR_CPUS patchset by rebasing on 2.6.24-rc8-mm1 (from 2.6.24-rc6-mm1)
and adding last minute changes suggested by reviews.

Based on 2.6.24-rc8-mm1

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---

-- 
