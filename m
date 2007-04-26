Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXDZFJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXDZFJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXDZFJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:09:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59440 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754713AbXDZFJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:09:34 -0400
Message-Id: <20070426050743.867613938@sgi.com>
User-Agent: quilt/0.45-1
Date: Wed, 25 Apr 2007 22:07:43 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/7] SLUB updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A series of updates to slub to make error reporting and recovery
more consistent. Rework sysfs behavior, make kmem_cache_shrink
perform fragmentation avoidance and update the slabinfo tool.

--
