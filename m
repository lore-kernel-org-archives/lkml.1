Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYGRBOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYGRBOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYGRBOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:14:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:56043 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbYGRBOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:14:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,206,1215414000"; 
   d="scan'208";a="598809167"
Subject: Re: 2.6.26 fails to boot on Acer TravelMate 5520 due to PCIE ASPM
From: Shaohua Li <shaohua.li@intel.com>
To: Pascal Terjan <pterjan@mandriva.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
In-Reply-To: <1216286420.26653.12.camel@plop>
References: <1216286420.26653.12.camel@plop>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 09:21:40 +0800
Message-Id: <1216344100.6105.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 11:20 +0200, Pascal Terjan wrote:
> When CONFIG_PCIEASPM is activated, Acer TravelMate 5520 will hang at
> "Setting up standard PCI resources"
> 
> pcie_noaspm does not seem to help
Can you double check it? With pcie_noaspm, the aspm driver does nothing.

Thanks,
Shaohua

