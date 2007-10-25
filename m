Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbXJYSjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbXJYSjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXJYSjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:39:35 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38461 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXJYSjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:39:35 -0400
X-IronPort-AV: E=Sophos;i="4.21,329,1188802800"; 
   d="scan'208";a="116804503"
Subject: Re: LTP ustat01 test fails on NFSROOT
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, neilb@suse.de, bfields@fieldses.org,
       chuck.lever@oracle.com
In-Reply-To: <6B3D0315-3441-45A1-A007-A193321B654A@kernel.crashing.org>
References: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org>
	 <1193188894.27073.20.camel@heimdal.trondhjem.org>
	 <1954B8FA-6E29-4FB7-86B0-EA43AF8F2AAF@kernel.crashing.org>
	 <2B2C1270-60FB-4830-A62C-D0357D2E1FB3@kernel.crashing.org>
	 <1193335168.7705.39.camel@heimdal.trondhjem.org>
	 <6B3D0315-3441-45A1-A007-A193321B654A@kernel.crashing.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 25 Oct 2007 14:39:49 -0400
Message-Id: <1193337589.7705.42.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 25 Oct 2007 18:39:19.0084 (UTC) FILETIME=[5A4EB6C0:01C81736]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-25 at 13:36 -0500, Kumar Gala wrote:
> On Oct 25, 2007, at 12:59 PM, Trond Myklebust wrote:
> 
> > Could you please try the following patch?
> 
> this fixes my issue.  Any reason this hasn't been accepted?

Do you mean apart from the fact that I wrote it a couple of hours
ago? :-)

Trond
