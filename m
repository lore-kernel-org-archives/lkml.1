Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbZJMXnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbZJMXnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZJMXnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:43:31 -0400
Received: from sous-sol.org ([216.99.217.87]:51764 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751768AbZJMXn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:43:29 -0400
Date: Tue, 13 Oct 2009 16:41:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alok Kataria <akataria@vmware.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
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
       Daniel Walker <dwalker@fifo99.com>, virtualization@lists.osdl.org,
       "virtualization@lists.linux-foundataion.org" 
	<virtualization@lists.linux-foundataion.org>
Subject: Re: SCSI driver for VMware's virtual HBA - V6.
Message-ID: <20091013234127.GA9024@sequoia.sous-sol.org>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com> <20091002004725.GP3958@sequoia.sous-sol.org> <1254789028.15233.54.camel@ank32.eng.vmware.com> <20091013053726.GE17547@sequoia.sous-sol.org> <1255470665.12792.105.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255470665.12792.105.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alok Kataria (akataria@vmware.com) wrote:
> SCSI driver for VMware's virtual HBA.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> This is a driver for VMware's paravirtualized SCSI device,
> which should improve disk performance for guests running
> under control of VMware hypervisors that support such devices.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>

Looks in good shape to me.

Reviewed-by: Chris Wright <chrisw@sous-sol.org>
