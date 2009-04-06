Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZDFSp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZDFSp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbZDFSps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:45:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:57618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZDFSpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:45:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="128439390"
Date: Mon, 6 Apr 2009 11:45:26 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PCI: allow PCI core hotplug to remove PCI root
 bus
Message-ID: <20090406114526.11a1e31e@hobbes>
In-Reply-To: <20090330165009.18855.43672.stgit@bob.kio>
References: <20090330164737.18855.7137.stgit@bob.kio>
	<20090330165009.18855.43672.stgit@bob.kio>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 10:50:09 -0600
Alex Chiang <achiang@hp.com> wrote:

> There is no reason to prevent removal of root bus devices. A
> subsequent rescan will find them just fine.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

Applied this series, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
