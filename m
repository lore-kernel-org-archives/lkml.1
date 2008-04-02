Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbYDBQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbYDBQ32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYDBQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:29:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53713 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbYDBQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:29:20 -0400
Message-ID: <47F3C24C.1090904@oracle.com>
Date: Wed, 02 Apr 2008 12:28:44 -0500
From: Richard Frank <richard.frank@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Shirley Ma <mashirle@us.ibm.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, rds-devel@oss.oracle.com
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's
 in infiniband.git)
References: <adave31bayd.fsf@cisco.com>	<1207120932.4593.47.camel@localhost.localdomain>	<aday77w2s5z.fsf@cisco.com> <47F3BE33.4000204@oracle.com>	<adalk3w2pxz.fsf@cisco.com> <47F3BFEC.1000400@oracle.com> <ada4pak2pfx.fsf@cisco.com>
In-Reply-To: <ada4pak2pfx.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

got it...

Roland Dreier wrote:
>  > Yes, I see this is for pushing RDS upstream - but what about running
>  > RDS as is over IWARP NICs - that should just work right ?
>
> No idea.  It depends on whether you took into account the differences
> between IB and iWARP.  Anyway that's not really what this thread was about.
>   
