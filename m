Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbZJIPTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbZJIPTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761108AbZJIPTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:19:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:46340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbZJIPTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:19:00 -0400
Date: Fri, 9 Oct 2009 17:18:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Anders Larsen <al@alarsen.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] qnx4fs: add missing KERN_xxx to printk() calls
In-Reply-To: <20090926181508.5461.7686.stgit@oscar.alarsen.net>
Message-ID: <alpine.LSU.2.00.0910091718100.19284@wotan.suse.de>
References: <20090926181508.5461.7686.stgit@oscar.alarsen.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009, Anders Larsen wrote:

> fixed printk calls to consistently specify a KERN_xxx level.

Applied to trivial queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
