Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZHLIeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZHLIeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZHLIeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:34:21 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61953 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbZHLIeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:34:21 -0400
Subject: Re: NULL pointer dereference in __put_nfs_open_context()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1250014185.26580.2.camel@heimdal.trondhjem.org>
References: <1249990719.27150.52.camel@pc1117.cambridge.arm.com>
	 <1249995530.12218.3.camel@heimdal.trondhjem.org>
	 <1250010984.30628.15.camel@pc1117.cambridge.arm.com>
	 <1250014185.26580.2.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 12 Aug 2009 09:34:13 +0100
Message-Id: <1250066053.20332.0.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 08:34:14.0156 (UTC) FILETIME=[AC4814C0:01CA1B27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 14:09 -0400, Trond Myklebust wrote:
> On Tue, 2009-08-11 at 18:16 +0100, Catalin Marinas wrote:
> > On Tue, 2009-08-11 at 08:58 -0400, Trond Myklebust wrote:
> > > How about the following instead? This patch gets rid of those
> > > nfs_open_context references altogether...
> > 
> > It fixes the kernel oops.
> > 
> > Thanks.
> 
> Can I mark that as a Tested-by? :-)

Yes.

-- 
Catalin

