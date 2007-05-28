Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbXE1BK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbXE1BK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXE1BKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:10:49 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60726 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbXE1BKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:10:48 -0400
X-IronPort-AV: i="4.14,585,1170662400"; 
   d="scan'208"; a="155192287:sNHT53474319"
To: David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, abraham.manu@gmail.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46584C30.4030206@gmail.com>
	<20070526.154910.78725926.davem@davemloft.net>
	<20070526235515.GA31023@colo.lackof.org>
	<20070526.170039.119261389.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 May 2007 18:10:46 -0700
In-Reply-To: <20070526.170039.119261389.davem@davemloft.net> (David Miller's message of "Sat, 26 May 2007 17:00:39 -0700 (PDT)")
Message-ID: <adatztx21nt.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2007 01:10:47.0182 (UTC) FILETIME=[05EDCAE0:01C7A0C5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm talking about embedded ARM chips and the like, and yes they
 > very possibly will be using PCI-E controllers at some point.

As an example the AMCC PowerPC 440SPe, which is an embedded SoC with
an onboard PCIe controller that supports three ports, has 24 MSI
interrupts that external PCIe devices can raise.
