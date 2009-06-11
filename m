Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZFKTB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZFKTB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbZFKTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:01:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:48060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759371AbZFKTBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:01:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="523695609"
Date: Thu, 11 Jun 2009 12:00:24 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: PCIE AER: Document for PCIE AER software error
 injection
Message-ID: <20090611120024.598f68cf@jbarnes-g45>
In-Reply-To: <1240541131.6842.682.camel@yhuang-dev.sh.intel.com>
References: <1240541131.6842.682.camel@yhuang-dev.sh.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 10:45:31 +0800
Huang Ying <ying.huang@intel.com> wrote:

> This patch add a minimal HOWTO for PCIE AER software error injection
> in Documentation/PCI/pcieaer-howto.txt.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  Documentation/PCI/pcieaer-howto.txt |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)

Applied this one (though it doesn't make much sense until the other
one is applied too :).

-- Jesse Barnes, Intel Open Source Technology Center
