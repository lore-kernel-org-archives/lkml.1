Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZEDRyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZEDRyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbZEDRyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:54:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45484 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbZEDRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:54:16 -0400
Date: Mon, 4 May 2009 11:54:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504175414.GC8822@parisc-linux.org>
References: <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1d4ao4wj2.fsf@fess.ebiederm.org> <20090504174931.GG6740@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504174931.GG6740@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 10:49:31AM -0700, Paul E. McKenney wrote:
> Ah, but you are not simply asking us to -do- our homework, but also to
> make that homework public on LKML.  Please note that Matthew's earlier
> email indicates that he does not expect to be able to convince his
> employer to make such homework public.

I have no data upon which to make a judgement as to the probability
of my lawyer doing anything.  The implication I took away from your
words earlier in this thread is that _no_ lawyer is going to permit
this homework to be published.  Maybe Intel's lawyers differ with IBM's
lawyers on this point.  I wouldn't know.

But all you're hearing from me is an echo of your own assertions, not
a concurrence.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
