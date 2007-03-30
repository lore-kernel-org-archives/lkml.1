Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXC3RBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXC3RBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbXC3RBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:01:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:9576 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbXC3RBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:01:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,354,1170662400"; 
   d="scan'208"; a="205685169:sNHT69176394"
Date: Fri, 30 Mar 2007 09:59:49 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
Message-ID: <20070330165949.GA19584@linux-os.sc.intel.com>
References: <1175273420.23240.3.camel@rousalka.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175273420.23240.3.camel@rousalka.dyndns.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 06:50:19PM +0200, Nicolas Mailhot wrote:
> Anyone got the same thing for CK804? I had my hopes high, and then I saw
> the DECLARE_PCI_FIXUP_HEADER values [and the thread title was
> misleading]
> 

Sorry about the wrong subject. It should have had ICH in the subject somewhere.
On the brighter side, if you find the chipset document for your chipset,
It should be as easy as this patch to force enable it :-).

Thanks,
Venki
