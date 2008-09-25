Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYIYS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYIYS4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYIYS4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:56:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:7127 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYIYS4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,309,1220252400"; 
   d="scan'208";a="51426794"
Date: Thu, 25 Sep 2008 11:56:04 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       dwmw2@infradead.org
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
Message-ID: <20080925185601.GE15609@linux-os.sc.intel.com>
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 12:28:25AM -0700, Yinghai Lu wrote:
> use early_acpi_os_unmap_memory
> 
> v2: move unmap_memory early...
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
