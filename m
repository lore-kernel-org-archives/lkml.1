Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbXFZWf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbXFZWf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbXFZWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:35:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33600 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbXFZWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:35:20 -0400
Date: Wed, 27 Jun 2007 00:35:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626223517.GA19395@one.firstfloor.org>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <46813E0F.1060806@linux.intel.com> <20070626173157.GD5244@one.firstfloor.org> <200706261310.16221.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706261310.16221.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Perhaps we just need an ioctl where an X server can switch this.
> 
> Switch what?  Turn on or off transparent translation?

Turn on/off bypass for its device.

-Andi
