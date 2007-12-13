Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbXLMOl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbXLMOl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXLMOlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:41:50 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:39646 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754725AbXLMOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:41:49 -0500
Date: Thu, 13 Dec 2007 20:11:06 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vincent Fortier <vincent.fortier1@EC.GC.CA>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213144106.GA5676@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071212134158.GA5547@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071213114336.GA5400@linux.vnet.ibm.com> <20071213125509.GA28340@elte.hu> <20071213130231.GB16905@linux.vnet.ibm.com> <1197552266.4936.2.camel@kayak.wul.qc.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197552266.4936.2.camel@kayak.wul.qc.ec.gc.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 01:24:26PM +0000, Vincent Fortier wrote:
> On Thu, 2007-12-13 at 18:32 +0530, Dhaval Giani wrote:
> > On Thu, Dec 13, 2007 at 01:55:09PM +0100, Ingo Molnar wrote:
> > > 
> > > * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > 
> > > > Could you please see if the following patch removes the oops due to 
> > > > CFS sysfs files? (There might still be the other oops due to the 
> > > > floppy sysfs files)
> > > > 
> > > > Ingo, could you please add this patch in your CFS backport to 2.6.22 
> > > > and older kernels?
> > > 
> > > sure - i've updated the backport patches with this fix.
> > > 
> > 
> > Thanks!
> 
> CFS v24 now does not apply correctly on a 2.6.22.15-rc1 here:

Could you try on 2.6.22.13/14, while we wait for Ingo ;).
-- 
regards,
Dhaval
