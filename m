Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZFKSoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZFKSoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZFKSn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:43:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:15315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZFKSn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="698570985"
Date: Thu, 11 Jun 2009 11:43:17 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/4] PCI: Add pci_bus_set_ops
Message-ID: <20090611114317.1b9a7d74@jbarnes-g45>
In-Reply-To: <1240541117.6842.676.camel@yhuang-dev.sh.intel.com>
References: <1240541117.6842.676.camel@yhuang-dev.sh.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 10:45:17 +0800
Huang Ying <ying.huang@intel.com> wrote:

> pci_bus_set_ops changes pci_ops associated with a pci_bus. This can be
> used by some debug tool such as PCIE AER error injection to fake some
> PCI configuration registers.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
