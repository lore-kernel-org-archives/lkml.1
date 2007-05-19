Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXESPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXESPGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbXESPFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:05:55 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:52656 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753AbXESPFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:05:54 -0400
X-Greylist: delayed 1192 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 11:05:54 EDT
Date: Sat, 19 May 2007 16:45:56 +0200
From: David Weinehall <tao@acc.umu.se>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: John Stoffel <john@stoffel.org>, Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070519144556.GS11766@vasa.acc.umu.se>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	John Stoffel <john@stoffel.org>, Jamie Lokier <jamie@shareable.org>,
	David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org> <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org> <20070516115003.GD5472@lazybastard.org> <17995.2550.581854.8393@stoffel.org> <20070516135318.GK5472@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516135318.GK5472@lazybastard.org>
X-Editor: Vi Improved <http://www.vim.org/>
X-Accept-Language: Swedish, English
X-GPG-Fingerprint: 7ACE 0FB0 7A74 F994 9B36  E1D1 D14E 8526 DC47 CA16
X-GPG-Key: http://www.acc.umu.se/~tao/files/pub_dc47ca16.gpg.asc
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 03:53:19PM +0200, J�rn Engel wrote:
> On Wed, 16 May 2007 09:41:10 -0400, John Stoffel wrote:
> > Jörn> On Wed, 16 May 2007 12:34:34 +0100, Jamie Lokier wrote:
> > 
> > Jörn> How many of you have worked for IBM before?  Vowels are not
> > evil. ;)
> > 
> > Nope, they're not.  I just think that LogFS isn't descriptive enough,
> > or more accurately, is the *wrong* description of this filesystem.  
> 
> That was the whole point.  JFFS2, the journaling flash filesystem, is a
> strictly log-structured filesystem.  LogFS has a journal.
> 
> It is also the filesystem that tries to scale logarithmically, as Arnd
> has noted.  Maybe I should call it Log2 to emphesize this point.  Log1
> would be horrible scalability.

So, log2fs...  Sounds great to me.

[snip]


Regards: David
-- 
 /) David Weinehall <tao@acc.umu.se> /) Northern lights wander      (\
//  Maintainer of the v2.0 kernel   //  Dance across the winter sky //
\)  http://www.acc.umu.se/~tao/    (/   Full colour fire           (/
