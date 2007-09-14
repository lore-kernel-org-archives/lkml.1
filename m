Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXINUMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXINUMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXINUML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:12:11 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2414 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbXINUMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:12:09 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
From: "Michael Chan" <mchan@broadcom.com>
To: "Roland Dreier" <rdreier@cisco.com>
cc: "Steve Wise" <swise@opengridcomputing.com>,
       "netdev" <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, anilgv@broadcom.com, uri@broadcom.com,
       talm@broadcom.com, lusinsky@broadcom.com
In-Reply-To: <adaveadjk5i.fsf@cisco.com>
References: <adahclymos8.fsf@cisco.com>
 <46E97BB0.9030106@opengridcomputing.com> <adaps0ml18e.fsf@cisco.com>
 <1189724358.9540.113.camel@dell> <adaveadjk5i.fsf@cisco.com>
Date: Fri, 14 Sep 2007 14:09:46 -0700
Message-ID: <1189804186.9540.173.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AF434853K4586155-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 09:18 -0700, Roland Dreier wrote:

> However, do you have any plans to support iSCSI offload for targets?
> Also, looking at the first CNIC patch, I can't help but notice that
> you seem to have at least some support for iWARP there.  How does the
> CNIC look?  Does it share the same interface/addresses as the
> non-offload NIC, or does it create a completely separate netdevice?

We will support iWARP in the future and it should be similar to the way
we do iSCSI - using the same interface/addresses as the bnx2 NIC.

> 
> I want to make sure that whatever solution we come up with for cxgb3
> doesn't cause problems for you.  And of course if you have a better
> idea than what Steve has come up with, that would be great :)
> 

We are looking at these discussions with great interest.  If we have any
new ideas, we'll definitely let everyone know.  Thanks.

