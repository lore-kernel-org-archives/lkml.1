Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZEDQPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZEDQPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZEDQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:15:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39216 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZEDQPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:15:43 -0400
Date: Mon, 4 May 2009 09:10:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504161024.GC6740@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090504063431.GK7141@linux.vnet.ibm.com> <m11vr5jrba.fsf@fess.ebiederm.org> <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <20090504153815.GB6740@linux.vnet.ibm.com> <20090504155505.GA8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504155505.GA8822@parisc-linux.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 09:55:06AM -0600, Matthew Wilcox wrote:
> On Mon, May 04, 2009 at 08:38:15AM -0700, Paul E. McKenney wrote:
> > On Mon, May 04, 2009 at 09:08:34AM -0600, Matthew Wilcox wrote:
> > > On Mon, May 04, 2009 at 07:39:19AM -0700, Paul E. McKenney wrote:
> > > > On Mon, May 04, 2009 at 07:21:19AM -0600, Matthew Wilcox wrote:
> > > > > Bringing the patch to a public mailing list is a waste of time until
> > > > > there's a reliable description of the problem you're trying to solve.
> > > > 
> > > > Please see the original patch.  It does describes what it is doing.
> > > 
> > > "What", but not "Why".  Which is only acceptable in GNU changelogs ;-)
> > 
> > ;-)
> > 
> > > Matthew Wilcox			Intel Open Source Technology Centre
> > 
> > Given your affiliation, you should have access to people with whom
> > you can have a meaningful conversation on the non-technical issues,
> > but without putting the Linux community at risk.
> 
> Indeed I do have access to lawyers.  But what use is that?  I could
> presumably get an opinion for myself that I would not then be able to
> share outside of Intel.

I am glad you understand our situation, then!  ;-)

> Can't you get the SFLC to issue a public legal opinion for you?  Or maybe
> the Linux Foundation?

I have no clue whether this would work, but it is certainly worth
exploring.  Thank you for the tip!!!

							Thanx, Paul
