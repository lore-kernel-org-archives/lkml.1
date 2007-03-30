Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXC3XGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXC3XGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXC3XGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:06:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:28529 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbXC3XGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,355,1170662400"; 
   d="scan'208"; a="205856190:sNHT19182443"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc5 0/3] iop13xx msi support and a couple msi cleanups
To: greg@kroah.com
Cc: linux@arm.linux.org.uk, linux-pci@atrey.karlin.mff.cuni.cz,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2007 16:05:44 -0700
Message-ID: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the latest revision of some patches that have been bouncing
around linux-pci for a while.  linux-kernel is copied to get a few more
eyes on the ARCH_SUPPORTS_MSI change.  To my knowledge these patches
have not yet been queued into a maintainer tree.

Dan Williams (2):
      msi: introduce ARCH_SUPPORTS_MSI Kconfig option (rev2)
      msi: fix ARM compile
 
Daniel Wolstenholme (1):
      iop13xx: msi support (rev6)

git pull git://lost.foo-projects.org/~dwillia2/git/iop msi

--
Dan
