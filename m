Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbZFKTA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbZFKTA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbZFKTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:00:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:53978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbZFKTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="420947998"
Date: Thu, 11 Jun 2009 11:59:54 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/4] PCI: PCIE AER: PCIE AER software error injection
Message-ID: <20090611115954.294581bb@jbarnes-g45>
In-Reply-To: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>
References: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 10:45:27 +0800
Huang Ying <ying.huang@intel.com> wrote:

> Debugging PCIE AER code can be very difficult because it is hard to
> trigger various real hardware errors. This patch provide a software
> based error injection tool, which can fake various PCIE errors with a
> user space helper tool named "aer-inject". Which can be gotten from:
> 
>   http://www.kernel.org/pub/linux/kernel/people/yhuang/
> 
> The patch fakes AER error by faking some PCIE AER related registers
> and an AER interrupt for specified the PCIE device.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 

This patch got mangled, care to resend?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
