Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0CIX3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:29:23 -0500
Received: from fieldses.org ([174.143.236.118]:52913 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab0CIX3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:29:17 -0500
Date: Tue, 9 Mar 2010 18:30:41 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond@netapp.com>
Subject: Re: linux-next: fetch of nfsd tree failed
Message-ID: <20100309233041.GC29261@fieldses.org>
References: <20100310100911.930ab78f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310100911.930ab78f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:09:11AM +1100, Stephen Rothwell wrote:
> Hi Bruce,
> 
> Today's linux-next fetch of the nfsd tree failed because I killed it
> after waiting for 15 minutes.  I can get a connection to the git server on
> git.linux-nfs.org, but then it just seems to hang.  I will use yesterday's
> nfsd tree for today.

linux-nfs.org is having trouble; investigating....

--b.
