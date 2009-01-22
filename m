Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZAVWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZAVWQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZAVWQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:16:31 -0500
Received: from ns1.suse.de ([195.135.220.2]:42307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZAVWQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:16:31 -0500
Date: Thu, 22 Jan 2009 14:15:08 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122221508.GA30019@suse.de>
References: <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <4978EBE1.9080403@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4978EBE1.9080403@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 01:57:53PM -0800, Randy Dunlap wrote:
> I agree that crap is the right name for lots of it.  For the ones that
> people & distros care about, someone should step up and do some real
> work on them.

Are people ignoring the fact that there _are_ people stepping up and
doing real work on these drivers?  Look at all of the cleanup patches
that went into 2.6.29-rc1 in drivers/staging.  There were hundreds.

And I already have 75+ staging cleanup patches in -next right now.

This work is being done right now, is it somehow being missed?

Yeah, compiler warnings are annoying, I totally agree, that is why it is
very hard to enable the staging tree.  To do so, you really have to want
to, and I'm eagerly taking any patch sent to me to do this work.

thanks,

greg k-h
