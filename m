Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbXK3Cc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbXK3Cc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763986AbXK3Ccs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:32:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:44705 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbXK3Ccr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:32:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,231,1194249600"; 
   d="scan'208";a="236466123"
Subject: Re: pnpacpi : exceeded the max number of IO resources
From: Shaohua Li <shaohua.li@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Dave Young <hidave.darkstar@gmail.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Zhao Yakui <yakui.zhao@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Renninger <trenn@suse.de>
In-Reply-To: <474F72E3.4040608@keyaccess.nl>
References: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>
	 <474F72E3.4040608@keyaccess.nl>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 10:32:19 +0800
Message-Id: <1196389939.7234.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-30 at 03:18 +0100, Rene Herman wrote:
> On 29-11-07 10:11, Dave Young wrote:
> 
> > The pnpacpi rsparser.c report warnings of:
> > exceeded the max number of IO resources: 24
> > 
> > dmesg|grep exceeded|wc
> >     66     594    3564
> 
> Heavens... (added CCs of people who just upped it from 8 -- I suppose the 
> problem is not new then?)
Properly we should make a bit bigger till Thomas's patch is ready.
Thomas, your patch isn't 2.6.24 staff, right?

Thanks,
Shaohua
