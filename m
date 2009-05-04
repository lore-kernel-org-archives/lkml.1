Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZEDQnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZEDQnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbZEDQmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:42:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56028 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbZEDQmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:42:51 -0400
Date: Mon, 4 May 2009 09:42:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       tridge@samba.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504164250.GF6740@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k54wal0j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 09:30:20AM -0700, Eric W. Biederman wrote:
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
> 
> > That's for the maintainers to decide.  If they agree it has worth, maybe
> > it's a good idea to answer "How".
> 
> Al and Christoph said essentially the same thing and they generally
> are considered the general area filesystem maintainers.
> 
> This kind of thing does not appear to have come up before and
> so procedurally you guys are setting are attempting to set
> a precedent.
> 
> All I know is that doing it the way you are doing seems like a bad
> idea.  Not discussing things or even the reason you can't discuss them
> seems foolish and leaves no one satisfied.
> 
> Maybe there are good reasons but so far this whole thing just stinks.
> 
> When all of the pieces are public how can having secret veiled reasons
> make sense?
> 
> And if secret magic consultations with lawyers are going to be invoked
> I expect we should have a Signed-off-by from those lawyers.

;-)

Matthew's idea of checking with SFLC seems to me to have some merit.
I am looking into this from my end.  Of course, you and Al and Christoph
have just as much standing to ask SFLC as do I, and perhaps more.

							Thanx, Paul
