Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYDBQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYDBQTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYDBQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:19:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48596 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbYDBQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:19:03 -0400
Message-ID: <47F3BFEC.1000400@oracle.com>
Date: Wed, 02 Apr 2008 12:18:36 -0500
From: Richard Frank <richard.frank@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Shirley Ma <mashirle@us.ibm.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, rds-devel@oss.oracle.com
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's
 in infiniband.git)
References: <adave31bayd.fsf@cisco.com>	<1207120932.4593.47.camel@localhost.localdomain>	<aday77w2s5z.fsf@cisco.com> <47F3BE33.4000204@oracle.com> <adalk3w2pxz.fsf@cisco.com>
In-Reply-To: <adalk3w2pxz.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I see this is for pushing RDS upstream - but what about running RDS 
as is over IWARP NICs - that should just work right ?

Roland Dreier wrote:
>  > What is the work we need to do here - I was thinking RDS should just work ?
>
> Stuff doesn't get merged into the kernel on its own.  If you want RDS
> upstream then the first step is to post patches in a form suitable for
> reviewing.  Then respond to the review comments.
>
> The files Documentation/SubmittingPatches and to some extent
> Documentation/SubmittingDrivers in the kernel source have more info.
>
>  - R.
>   
