Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbZJBAtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbZJBAtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZJBAtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:49:17 -0400
Received: from sous-sol.org ([216.99.217.87]:46824 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752696AbZJBAtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:49:17 -0400
Date: Thu, 1 Oct 2009 17:47:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alok Kataria <akataria@vmware.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Bart Van Assche <bvanassche@acm.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Robert Love <robert.w.love@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.linux-foundataion.org
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Message-ID: <20091002004725.GP3958@sequoia.sous-sol.org>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254336812.19921.23.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alok Kataria (akataria@vmware.com) wrote:
> VMware PVSCSI driver - v5.

Were you still planning on renaming the driver to something less generic
(like vmw_pvscsi)?

thanks,
-chris
