Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZJ1U2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZJ1U2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZJ1U2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:28:36 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:38472 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbZJ1U2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:28:35 -0400
Subject: Re: SCSI driver for VMware's virtual HBA - V6.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <randy.dunlap@oracle.com>,
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
       Daniel Walker <dwalker@fifo99.com>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       "virtualization@lists.linux-foundataion.org" 
	<virtualization@lists.linux-foundataion.org>
In-Reply-To: <20091013234127.GA9024@sequoia.sous-sol.org>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254789028.15233.54.camel@ank32.eng.vmware.com>
	 <20091013053726.GE17547@sequoia.sous-sol.org>
	 <1255470665.12792.105.camel@ank32.eng.vmware.com>
	 <20091013234127.GA9024@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 28 Oct 2009 13:28:40 -0700
Message-Id: <1256761720.22354.74.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-10-13 at 16:41 -0700, Chris Wright wrote: 
> * Alok Kataria (akataria@vmware.com) wrote:
> > SCSI driver for VMware's virtual HBA.
> > 
> > From: Alok N Kataria <akataria@vmware.com>
> > 
> > This is a driver for VMware's paravirtualized SCSI device,
> > which should improve disk performance for guests running
> > under control of VMware hypervisors that support such devices.
> > 
> > Signed-off-by: Alok N Kataria <akataria@vmware.com>
> 
> Looks in good shape to me.
> 
> Reviewed-by: Chris Wright <chrisw@sous-sol.org>

<ping>

This seems to have slipped through the cracks, maybe all the conferences
last week managed to take our attention off this :-).

I just checked the SCSI tree and don't see this merged in any of those
trees yet, though I don't think there is anything else that's pending on
for the driver merge. Some feedback about when this can be merged will
be really helpful.

Thanks,
Alok

