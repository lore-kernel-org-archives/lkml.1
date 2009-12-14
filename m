Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZLNIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZLNIo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZLNIo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:44:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:29378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZLNIo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:44:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,391,1257148800"; 
   d="scan'208";a="522817731"
Subject: Re: [PATCH 5/5 -v2] acpi, apei, Document for APEI
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200912110958.29319.bjorn.helgaas@hp.com>
References: <1260429424.15264.397.camel@yhuang-dev.sh.intel.com>
	 <200912110958.29319.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 16:44:55 +0800
Message-ID: <1260780295.12561.118.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-12 at 00:58 +0800, Bjorn Helgaas wrote: 
> On Thursday 10 December 2009 12:17:04 am Huang Ying wrote:
> > Add document for APEI, including kernel parameters and EINJ debug file
> > sytem interface.
> 
> From a stylistic point of view, I think it's better if the
> documentation is added by the same patch that adds the functionality.
> Having them in separate patches means there's a point in time where
> the tree contains the functionality but not the documentation, or
> vice versa.

Sounds reasonable, I will change this.

Best Regards,
Huang Ying

