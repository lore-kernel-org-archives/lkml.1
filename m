Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZEDWSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZEDWSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZEDWSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:18:24 -0400
Received: from kroah.org ([198.145.64.141]:50782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZEDWSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:18:23 -0400
Date: Mon, 4 May 2009 15:12:08 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504221208.GB29402@kroah.com>
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <20090504153815.GB6740@linux.vnet.ibm.com> <20090504155505.GA8822@parisc-linux.org> <20090504161024.GC6740@linux.vnet.ibm.com> <20090504162252.GB8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504162252.GB8822@parisc-linux.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 10:22:52AM -0600, Matthew Wilcox wrote:
> On Mon, May 04, 2009 at 09:10:24AM -0700, Paul E. McKenney wrote:
> > On Mon, May 04, 2009 at 09:55:06AM -0600, Matthew Wilcox wrote:
> > > Indeed I do have access to lawyers.  But what use is that?  I could
> > > presumably get an opinion for myself that I would not then be able to
> > > share outside of Intel.
> > 
> > I am glad you understand our situation, then!  ;-)
> 
> I'm assuming my situation would be analagous to yours.  That doesn't
> mean that I understand your situation at all.
> 
> > > Can't you get the SFLC to issue a public legal opinion for you?  Or maybe
> > > the Linux Foundation?
> > 
> > I have no clue whether this would work, but it is certainly worth
> > exploring.  Thank you for the tip!!!
> 
> No problem.  I'm always looking for ways to solve problems.
> 
> I've never trusted advice from IBM laywers, ever since Greg spouted some
> utter rubbish about the Copyright symbol that completely contradicts
> US law.

Doubt is good when dealing with lawyers :)

But what was wrong with what they told us to do with regards to how to
specify the copyright on a file?  I don't recall seeing anything that
contridicted what I was told, but that was many many years ago, so I
probably am forgetting...

thanks,

greg k-h
