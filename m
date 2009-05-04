Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZEDMlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZEDMlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZEDMlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:41:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55947 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbZEDMlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:41:24 -0400
Date: Mon, 4 May 2009 05:41:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: tridge@samba.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504124129.GL7141@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090503225616.GD8633@ZenIV.linux.org.uk> <20090504063431.GK7141@linux.vnet.ibm.com> <m11vr5jrba.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vr5jrba.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:49:29PM -0700, Eric W. Biederman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Sun, May 03, 2009 at 10:42:52PM -0700, Eric W. Biederman wrote:
> >> The only reason I can see for not ultimately talking about things publicly
> >> is if this is one company making shady deals with another company in which
> >> case I do not see why the maintenance burden for those decision should
> >> fall on the linux community as a whole.
> >
> > Another reason is that past experience would indicate that anything we
> > say in public and and will be used against us.
> 
> Which is a fine reason to be careful what you say, and to say
> reasonable things.

I am glad you agree.

>                    It is not a reason to submit a patch without
> justification.
> 
> If the reason for submitting a patch is not sufficiently good to be
> held to then it appears insufficient to merge the patch.
> 
> Why should the commit to a position at your urging that you aren't
> willing to commit to?

I am not sure that I correctly parsed these three sentences, but the
justification should be pretty clear to anyone who has been paying any
attention at all to recent industry news.

							Thanx, Paul
