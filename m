Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZCJBK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZCJBK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZCJBKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:10:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:32362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZCJBKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,332,1233561600"; 
   d="scan'208";a="496423369"
Date: Tue, 10 Mar 2009 09:11:46 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090310011146.GA5063@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <20090306194411.GC25995@parisc-linux.org> <20090307023454.GC3596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307023454.GC3596@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 10:34:54AM +0800, Greg KH wrote:
> On Fri, Mar 06, 2009 at 12:44:11PM -0700, Matthew Wilcox wrote:
> > > Physical Function driver patches for Intel 82576 NIC are available:
> > >   http://patchwork.kernel.org/patch/8063/
> > >   http://patchwork.kernel.org/patch/8064/
> > >   http://patchwork.kernel.org/patch/8065/
> > >   http://patchwork.kernel.org/patch/8066/
> > 
> > I need to review this driver; I haven't done that yet.  Has anyone else?
> 
> The driver was rejected by the upstream developers, who said it would
> never be accepted.

Sorry I didn't make it clear. These Physical Function driver patches are
new ones that have been accepted by David Miller (net-next-2.6).
The old ones I sent last time are for demonstration purpose, and won't
be in any upstream trees.

Thanks,
Yu
