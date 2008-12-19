Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYLSNXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYLSNXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYLSNXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:23:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39943 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYLSNXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:23:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081219040952.GB7552@fieldses.org>
References: <20081219040952.GB7552@fieldses.org> <7633.1229653644@redhat.com> <7A24DF798E223B4C9864E8F92E8C93EC01AAF3F8@SACMVEXC1-PRD.hq.netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, "Muntz, Daniel" <Dan.Muntz@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 13:22:57 +0000
Message-ID: <10947.1229692977@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > Local disk cache was great for AFS back around 1992.  Typical networks
> > were 10 or 100Mbps (slower than disk access at the time),
> 
> Would a disk cache on SSD make any sense?  Seems like it'd change the
> latency tradeoff.

It could, as could using a battery backed RAM cache.

David
