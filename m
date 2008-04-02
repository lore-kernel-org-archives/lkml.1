Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYDBQbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYDBQbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbYDBQbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:31:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54375 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbYDBQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:31:20 -0400
Message-ID: <47F3C137.3070209@oracle.com>
Date: Wed, 02 Apr 2008 12:24:07 -0500
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

WRT to merging RDS into the kernel - our current plans are to wait to 
see RDS adopted by more than Oracle - before approaching the kernel 
community about inclusion of RDS.

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
