Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYLTBUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYLTBUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYLTBUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:20:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57657 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYLTBUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:20:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <OF4F5F89AF.8F313531-ON88257524.006A611A-88257524.006D49B8@us.ibm.com>
References: <OF4F5F89AF.8F313531-ON88257524.006A611A-88257524.006D49B8@us.ibm.com>
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: dhowells@redhat.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Muntz, Daniel" <Dan.Muntz@netapp.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org, rwheeler@redhat.com,
       sfr@canb.auug.org.au, steved@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Sat, 20 Dec 2008 01:20:05 +0000
Message-ID: <13180.1229736005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson <hbryan@us.ibm.com> wrote:

> > > AFS was designed to support local disk cache, so with callbacks you can
> > > get a consistent system.
> > 
> > It's less the callbacks and more the data version number that's important.
> 
> Maybe for consistency, but for the performance benefits of local disk
> caching, I believe the callbacks are pretty important.

Indeed, but he said "so with callbacks you can get a _consistent_ system".

David
