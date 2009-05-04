Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZEDPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZEDPz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZEDPzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:55:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42763 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZEDPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:55:06 -0400
Date: Mon, 4 May 2009 09:55:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504155505.GA8822@parisc-linux.org>
References: <20090503225616.GD8633@ZenIV.linux.org.uk> <20090504063431.GK7141@linux.vnet.ibm.com> <m11vr5jrba.fsf@fess.ebiederm.org> <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <20090504153815.GB6740@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504153815.GB6740@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 08:38:15AM -0700, Paul E. McKenney wrote:
> On Mon, May 04, 2009 at 09:08:34AM -0600, Matthew Wilcox wrote:
> > On Mon, May 04, 2009 at 07:39:19AM -0700, Paul E. McKenney wrote:
> > > On Mon, May 04, 2009 at 07:21:19AM -0600, Matthew Wilcox wrote:
> > > > Bringing the patch to a public mailing list is a waste of time until
> > > > there's a reliable description of the problem you're trying to solve.
> > > 
> > > Please see the original patch.  It does describes what it is doing.
> > 
> > "What", but not "Why".  Which is only acceptable in GNU changelogs ;-)
> 
> ;-)
> 
> > Matthew Wilcox			Intel Open Source Technology Centre
> 
> Given your affiliation, you should have access to people with whom
> you can have a meaningful conversation on the non-technical issues,
> but without putting the Linux community at risk.

Indeed I do have access to lawyers.  But what use is that?  I could
presumably get an opinion for myself that I would not then be able to
share outside of Intel.

Can't you get the SFLC to issue a public legal opinion for you?  Or maybe
the Linux Foundation?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
