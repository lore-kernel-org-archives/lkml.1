Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZEECCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZEECCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 22:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZEECBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 22:01:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46206 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZEECBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 22:01:50 -0400
Date: Mon, 4 May 2009 20:01:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
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
Message-ID: <20090505020149.GE8822@parisc-linux.org>
References: <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <20090504153815.GB6740@linux.vnet.ibm.com> <20090504155505.GA8822@parisc-linux.org> <20090504161024.GC6740@linux.vnet.ibm.com> <20090504162252.GB8822@parisc-linux.org> <20090504221208.GB29402@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504221208.GB29402@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 03:12:08PM -0700, Greg KH wrote:
> But what was wrong with what they told us to do with regards to how to
> specify the copyright on a file?  I don't recall seeing anything that
> contridicted what I was told, but that was many many years ago, so I
> probably am forgetting...

I don't remember exactly, and can't be bothered to look it up.  It was
something along the lines of you saying an IBM lawyer had told you
that in:

Copyright (c) 2009

the (c) was a non-optional part.  I found something that said the (c)
had no legal meaning.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
