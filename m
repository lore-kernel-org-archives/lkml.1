Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZEDOjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZEDOjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZEDOj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:39:27 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48583 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZEDOj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:39:26 -0400
Date: Mon, 4 May 2009 07:39:19 -0700
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
Message-ID: <20090504143919.GA6740@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090503225616.GD8633@ZenIV.linux.org.uk> <20090504063431.GK7141@linux.vnet.ibm.com> <m11vr5jrba.fsf@fess.ebiederm.org> <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504132119.GX8822@parisc-linux.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 07:21:19AM -0600, Matthew Wilcox wrote:
> On Mon, May 04, 2009 at 06:06:38AM -0700, Paul E. McKenney wrote:
> > On Mon, May 04, 2009 at 06:44:33AM -0600, Matthew Wilcox wrote:
> > > On Mon, May 04, 2009 at 05:41:29AM -0700, Paul E. McKenney wrote:
> > > > I am not sure that I correctly parsed these three sentences, but the
> > > > justification should be pretty clear to anyone who has been paying any
> > > > attention at all to recent industry news.
> > > 
> > > I think if there's one thing less reliable than an engineer's opinion
> > > on a patent, it's a journalist's opinion on a patent lawsuit.
> > 
> > And hence discussing these sorts of non-technical issues on LKML is kind
> > of pointless, you are saying?  I certainly cannot disagree with that!
> 
> Bringing the patch to a public mailing list is a waste of time until
> there's a reliable description of the problem you're trying to solve.

Please see the original patch.  It does describes what it is doing.

> All this innuendo is terribly unbecoming.

Ack that!!!

							Thanx, Paul
