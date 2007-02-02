Return-Path: <linux-kernel-owner+w=401wt.eu-S1945943AbXBBQXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945943AbXBBQXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945968AbXBBQXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:23:41 -0500
Received: from rgminet02.oracle.com ([148.87.113.119]:46049 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945943AbXBBQXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:23:40 -0500
Message-ID: <45C363BE.50205@oracle.com>
Date: Fri, 02 Feb 2007 11:15:58 -0500
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 000 of 14] knfsd: Preparation for IPv6 support in
 NFS server.
References: <20070202153531.18622.patches@notabene> <adahcu55fiu.fsf@cisco.com>
In-Reply-To: <adahcu55fiu.fsf@cisco.com>
Content-Type: multipart/mixed;
 boundary="------------030008010605070805070602"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030008010605070805070602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Roland Dreier wrote:
>  > They are mostly from Chuck Level and make preparating for IPv6 support
>  > in the NFS server.
>  > They are *not* for 2.6.20, but should be ok for .21.
> 
> Out of curiousity, does this patch series reduce the delta between the
> NFS/RDMA tree and mainline Linux?  In other words does this bring
> NFS/RDMA closer to merging?

Hi Roland-

The client side support for an RPC/RDMA module is almost completely 
integrated into mainline.  There is still a minimal set of patches 
required to support alternate transports in loadable kernel modules 
which Trond has indicated he will integrate when the RPC/RDMA transport 
is ready to be integrated.

At this time I'm not aware of a plan to integrate server-side support 
for NFS/RDMA.  Perhaps the NetApp RDMA developers could respond.

--------------030008010605070805070602
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture Linux Projects Group
email;internet:chuck dot lever at nospam oracle dot com
title:Principle Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------030008010605070805070602--
