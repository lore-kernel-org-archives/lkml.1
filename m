Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbXBMXQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbXBMXQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXBMXQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:16:55 -0500
Received: from mail.fieldses.org ([66.93.2.214]:52581 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbXBMXQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:16:54 -0500
Date: Tue, 13 Feb 2007 18:16:52 -0500
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Menny Hamburger <menny@exanet.com>, linux-kernel@vger.kernel.org
Subject: Re: Getting the nfs_fh of a specific file/dir from the kernel
Message-ID: <20070213231652.GA19243@fieldses.org>
References: <A6FDE6B975803043804A49F12F49028E0F573D@hawk.exanet-il.co.il> <1171408381.6031.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171408381.6031.1.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 03:13:01PM -0800, Trond Myklebust wrote:
> On Sun, 2007-02-11 at 10:06 +0200, Menny Hamburger wrote:
> > We implement our own nfsd in user space - so the  kernel nfsd (as well
> > as the lockd) are disabled.
> > We need the handle in order to associate a kernel file handle with our
> > own file id.
> 
> Filehandles are not part of any API that is exported to userland.

/proc/fs/nfsd/filehandle ???

--b.
