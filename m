Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZEDPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZEDPg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZEDPgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:36:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41581 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbZEDPgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:36:44 -0400
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090504150834.GZ8822@parisc-linux.org>
References: <20090501210109.GA3079@infradead.org>
	 <20090502013729.GI6996@linux.vnet.ibm.com>
	 <20090503225616.GD8633@ZenIV.linux.org.uk>
	 <20090504063431.GK7141@linux.vnet.ibm.com>
	 <m11vr5jrba.fsf@fess.ebiederm.org>
	 <20090504124129.GL7141@linux.vnet.ibm.com>
	 <20090504124433.GW8822@parisc-linux.org>
	 <20090504130638.GN7141@linux.vnet.ibm.com>
	 <20090504132119.GX8822@parisc-linux.org>
	 <20090504143919.GA6740@linux.vnet.ibm.com>
	 <20090504150834.GZ8822@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 04 May 2009 10:36:31 -0500
Message-Id: <1241451391.20170.12.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 09:08 -0600, Matthew Wilcox wrote:
> On Mon, May 04, 2009 at 07:39:19AM -0700, Paul E. McKenney wrote:
> > On Mon, May 04, 2009 at 07:21:19AM -0600, Matthew Wilcox wrote:
> > > Bringing the patch to a public mailing list is a waste of time until
> > > there's a reliable description of the problem you're trying to solve.
> > 
> > Please see the original patch.  It does describes what it is doing.
> 
> "What", but not "Why".  Which is only acceptable in GNU changelogs ;-)

Please understand the "Why" is a sticky subject that we can't and won't
discuss in a public forum.  However, we believe the maintainers
understand the "Why" of it well enough to consider whether or not to
include such a patch.  The "What" should be pretty clear from the patch
description.  The "How" is a technical question that can be discussed
here.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

