Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXINSgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXINSgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXINSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:36:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49895 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbXINSgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:36:15 -0400
In-Reply-To: <adazlzpjkk6.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF1B5CCF10.3CE4B194-ON87257356.00661AD2-88257356.0065F05E@us.ibm.com>
From: Shirley Ma <xma@us.ibm.com>
Date: Fri, 14 Sep 2007 11:36:12 -0700
X-MIMETrack: Serialize by Router on D03NM124/03/M/IBM(Release 7.0.2FP2HF51 | June 19, 2007) at
 09/14/2007 12:36:13,
	Serialize complete at 09/14/2007 12:36:13
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> IPoIB CM handles this properly by gathering together single pages in
> skbs' fragment lists.
> 
>  - R.

Then can we reuse IPoIB CM code here?

Thanks
Shirley 

