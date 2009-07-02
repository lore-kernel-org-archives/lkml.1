Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZGBP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZGBP2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZGBP1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:27:45 -0400
Received: from THUNK.ORG ([69.25.196.29]:57254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbZGBP1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:27:43 -0400
Date: Thu, 2 Jul 2009 11:27:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, tridge@samba.org,
       Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702152727.GB30665@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, tridge@samba.org,
	Pavel Machek <pavel@ucw.cz>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org> <20090701123141.402c17d2@lxorguk.ukuu.org.uk> <19019.25035.244941.352337@samba.org> <20090701143844.07728fdf@lxorguk.ukuu.org.uk> <19019.27736.647500.497114@samba.org> <20090701154151.7f45abad@lxorguk.ukuu.org.uk> <19020.12748.348370.708306@samba.org> <20090702113200.39a15f21@lxorguk.ukuu.org.uk> <1246546567.4055.27.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246546567.4055.27.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 02:56:07PM +0000, James Bottomley wrote:
>      3. For this patch, since there are legal issues which could harm
>         the defence of any company to be discussed openly, the LF is
>         paying the retainer for John Lanza to be available to any member
>         of the community on a one on one basis, so that the discussions
>         they engage in would be protected by client privilege (i.e. not
>         subject to discovery).

I believe what has been made available is that people who have some
detailed legal questions can contact John Lanza who can either respond
off-line via e-mail, schedule time for a phone call, and if really
necessary, it _can_ be possible to establish a formal client/attorney
privilege with John.  These different options are listed in order of
increasing cost to the Linux Foundation.  

Which option gets chosen will depend on the specific question and who
is asking the question; which is to say, setting up a formal
client/attorney privilege might be more appropriate for Hirofumi or
Linus, but obviously the LF can't afford to set up relationships where
client privilege would apply for any random LKML reader who is
randomly curious about the way things work.

So just to make it clear, with respect to expectations, simply sending
e-mail to John doesn't automatically set up a client relationship that
which protects the discussion under client/attorney privilege.
Setting that up *does* cost LF real money, so I would ask folks to be
considerate about the LF's resources!

BTW, Tridge has offered to be available for phone conversations, since
he's probably asked the various lawyers that have been consulted most
of the questions that people might have; so that's another option for
people who have legal questions that would be kinder and gentler to
the LF's budget.

And of course, keep in mind that this offer is really only for people
who want to clarification of any background legal issues, not to
debate the issue of whether or not the patch should go in.  That
policy discussion should happen openly, like any other proposed patch,
and ultimately it's Hirofumi-san's and/or Linus's call.

						- Ted
