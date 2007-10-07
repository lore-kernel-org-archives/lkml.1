Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXJGCBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXJGCBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 22:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXJGCA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 22:00:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59343 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbXJGCAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 22:00:55 -0400
Message-ID: <47083E38.2050005@linux.vnet.ibm.com>
Date: Sat, 06 Oct 2007 19:02:32 -0700
From: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
References: <adaodfdkv59.fsf@cisco.com>
In-Reply-To: <adaodfdkv59.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> ULPs:
> 
>  - Pradeep's IPoIB CM support for devices that don't have SRQs.  Sean
>    started reviewing but I didn't see any updated patches.
> 
Roland, I submitted an updated patch incorporating some of Sean's comments within
a day or two. Rest of comments pertained to restructuring the code and adding 
some additional module parameters.

This would require more discussions since some of these had been already discussed
previously. We had decided upon this code structure after a lot of discussions and
incorporating these would be undoing some of that.

We can discuss and revisit the comments after the merge.

Pradeep

