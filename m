Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbXEYQhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbXEYQhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763967AbXEYQg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:36:57 -0400
Received: from waste.org ([66.93.16.53]:50131 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763939AbXEYQg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:36:56 -0400
Date: Fri, 25 May 2007 11:36:22 -0500
From: Matt Mackall <mpm@selenic.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, yi.zhu@intel.com
Subject: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-ID: <20070525163621.GE11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-rc2 works. CONFIG_SYSFS_DEPRECATED = y, though that shouldn't
matter. Bringing up the interface manually still works, so I suspect
this is sysfs or HAL related again. Again, Debian unstable so
userspace is quite up-to-date.

-- 
Mathematics is the supreme nostalgia of our time.
