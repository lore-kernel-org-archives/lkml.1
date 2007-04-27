Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbXD0QxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbXD0QxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXD0QxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:53:12 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:32369 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXD0QxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:53:10 -0400
Message-ID: <46322A67.5070608@chelsio.com>
Date: Fri, 27 Apr 2007 09:52:55 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Steve Wise <swise@opengridcomputing.com>, jeff@garzik.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.22 5/5] iw_cxgb3: Update required firmware revision
 to 4.0.0.
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>	<20070426202126.24234.71523.stgit@dell3.ogc.int> <adaps5qo6hh.fsf@cisco.com>
In-Reply-To: <adaps5qo6hh.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Apr 2007 16:52:58.0575 (UTC) FILETIME=[82758DF0:01C788EC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Update required firmware revision to 4.0.0.
>
> Hmm... should we fold this into the earlier patch, which actually
> needs this new FW?  Or at least merge this patch first?
>
> Also, is it cool with everyone to require a new FW, even for users who
> might not be using (or even building) the RDMA driver?  I'm not sure
> what a good solution would be really, so maybe the pain of forcing
> everyone to update FW is the least bad thing to do.
>
>  
Hi Roland,

The FW update required code changes in the RDMA driver, so Steve took 
care of submitting the update patch.
The new FW is required for the NIC driver too.

Cheers,
Divy
