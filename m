Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbXFVTRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbXFVTRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXFVTQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:16:55 -0400
Received: from thunk.org ([69.25.196.29]:51870 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbXFVTQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:16:55 -0400
Date: Fri, 22 Jun 2007 15:16:28 -0400
From: Theodore Tso <tytso@mit.edu>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.06
Message-ID: <20070622191628.GH15285@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Hansen <hansendc@us.ibm.com>,
	Joel Schopp <jschopp@austin.ibm.com>,
	Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
References: <e12915ec7c0cfcb5d6a7c4432f458161@pinky> <1182532151.26162.45.camel@localhost> <467C0CE9.5010502@austin.ibm.com> <1182535330.26162.50.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182535330.26162.50.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 11:02:10AM -0700, Dave Hansen wrote:
> On Fri, 2007-06-22 at 12:54 -0500, Joel Schopp wrote:
> > If it is "kinda like a mini function" why not make it "actually a mini
> > function" and call it? 
> 
> Several of our on-disk filesystems have an ioctl function that already
> has indented goto labels.  I don't think it's quite worth churning all
> of these (working) filesystems to make a style checker happy.

It's not just the on-disk filesystem code.  There are examples of both
styles of indentation many other parts of the kernel as well.

						- Ted
