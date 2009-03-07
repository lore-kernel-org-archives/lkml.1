Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZCGC6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZCGC6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 21:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbZCGC5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 21:57:31 -0500
Received: from kroah.org ([198.145.64.141]:35950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754381AbZCGC5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 21:57:30 -0500
Date: Fri, 6 Mar 2009 18:34:54 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090307023454.GC3596@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <20090306194411.GC25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306194411.GC25995@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:44:11PM -0700, Matthew Wilcox wrote:
> > Physical Function driver patches for Intel 82576 NIC are available:
> >   http://patchwork.kernel.org/patch/8063/
> >   http://patchwork.kernel.org/patch/8064/
> >   http://patchwork.kernel.org/patch/8065/
> >   http://patchwork.kernel.org/patch/8066/
> 
> I need to review this driver; I haven't done that yet.  Has anyone else?

The driver was rejected by the upstream developers, who said it would
never be accepted.

thanks,

greg k-h
