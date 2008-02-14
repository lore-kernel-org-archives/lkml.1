Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbYBNUol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbYBNUol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYBNUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:44:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYBNUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:44:30 -0500
Date: Thu, 14 Feb 2008 12:42:09 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alasdair G Kergon <agk@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: quilt series
Message-ID: <20080214204209.GA17277@kroah.com>
References: <20080215014210.73c71078.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215014210.73c71078.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 01:42:10AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> To make my life easier, can I ask that the series file for any quilt trees in the linux-next tree have a comment at the top to identify their base (either a SHA1 or some other ref in Linus' tree).  Like this:
> 
> # BASE <SHA1 or ref>

My trees are now marked with this.

> Also, if you only want a subset of the series file included, you can mark the patches with
> 
> # NEXT_PATCHES_START
> 	.
> 	.
> # NEXT_PATCHES_END

Oh, that's nice.

Can we write these things down somewhere on the web so that I, and
others, remember them in a few months?  :)

thanks,

greg k-h
