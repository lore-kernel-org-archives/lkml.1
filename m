Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYBPPOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYBPPOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYBPPOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:14:39 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42186 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbYBPPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:14:37 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20080215120222.b3263e4a.sfr@canb.auug.org.au>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	 <adalk5np1h5.fsf@cisco.com>  <20080215120222.b3263e4a.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 09:14:32 -0600
Message-Id: <1203174872.3182.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 12:02 +1100, Stephen Rothwell wrote:
> Hi Roland,
> 
> On Thu, 14 Feb 2008 15:22:46 -0800 Roland Dreier <rdreier@cisco.com> wrote:
> >
> > For InfiniBand/RDMA, the tree is:
> > 
> >     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-next
> > 
> > or via git protocol:
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
> > 
> > contact addresses (me plus a mailing list):
> > 
> >     rolandd@cisco.com
> >     general@lists.openfabrics.org
> 
> Added, thanks.

Do you have the tree and build logs available anywhere?  I'd like to
turn off the merge tree builds when this is able to replace it.

James


