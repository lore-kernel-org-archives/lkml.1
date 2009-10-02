Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZJBBn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZJBBn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZJBBnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:43:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbZJBBnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:43:21 -0400
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
From: James Bottomley <James.Bottomley@suse.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Alok Kataria <akataria@vmware.com>, Randy Dunlap <randy.dunlap@oracle.com>,
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
       Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <20091002004725.GP3958@sequoia.sous-sol.org>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 01:43:12 +0000
Message-Id: <1254447792.3885.72.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 17:47 -0700, Chris Wright wrote:
> * Alok Kataria (akataria@vmware.com) wrote:
> > VMware PVSCSI driver - v5.
> 
> Were you still planning on renaming the driver to something less generic
> (like vmw_pvscsi)?

Actually it's not a paravirt driver either, so something like
vmwarevscsi would be fine.

James


