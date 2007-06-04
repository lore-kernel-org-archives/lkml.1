Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbXFDXEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbXFDXEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXFDXD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:03:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38364 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXFDXD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:03:57 -0400
Date: Mon, 4 Jun 2007 19:03:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 01/10] DMAR detection and parsing logic
Message-ID: <20070604230356.GN20299@havoc.gtf.org>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.076940000@askeshav-devel.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604210644.076940000@askeshav-devel.jf.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Is there no way at all, other than ACPI, to find this stuff?

We would prefer to avoid hardware if the hardware enumeration is sane.

	Jeff



