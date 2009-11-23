Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbZKWXkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbZKWXkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbZKWXkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:40:04 -0500
Received: from kroah.org ([198.145.64.141]:37747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZKWXkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:40:02 -0500
Date: Mon, 23 Nov 2009 15:39:23 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
Message-ID: <20091123233923.GA13539@kroah.com>
References: <20091123185232.1423c56b.sfr@canb.auug.org.au>
 <20091123111510.9b0c0714.randy.dunlap@oracle.com>
 <200911240924.54675.rusty@rustcorp.com.au>
 <20091124103318.bfcb504c.sfr@canb.auug.org.au>
 <4B0B1BFE.9030508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B1BFE.9030508@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:34:22PM -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi Rusty,
> > 
> > On Tue, 24 Nov 2009 09:24:54 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >>     And I guess linux-next doesn't build staging?
> > 
> > Correct - it breaks to much and too often :-)
> > 
> 
> then you would need to drop it. and then no problem.  ;)

No, we want the merge issues to be known about, and others use
linux-next to do -staging development on.

thanks,

greg k-h
