Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbZCSGXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbZCSGXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZCSGXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:23:37 -0400
Received: from indigo.cs.bgu.ac.il ([132.72.42.23]:48443 "EHLO
	indigo.cs.bgu.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZCSGXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:23:36 -0400
Date: Thu, 19 Mar 2009 08:23:30 +0200 (IST)
Message-Id: <200903190623.n2J6NUjX012933@indigo.cs.bgu.ac.il>
From: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on 2.6.28
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Organization: CS Department
X-Mailer: CS Webmail v3.10
In-Reply-To: <20090223171030.GA5925@joi>
X-Priority: 3 (Normal)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon 23 Feb 19:10 2009 Marcin Slusarz wrote:
> On Mon, Feb 23, 2009 at 08:38:42AM +0200, eial@cs.bgu.ac.il wrote:
> > On Fri 20 Feb 21:24 2009 eial@cs.bgu.ac.il wrote:
> > > 
> > > hello, I'm having a kernel panic with kernel 2.6.28 upon shutdown right after unmounting remaining file system under gentoo.
> > > I've enabled kernel dump feature in the kernel but I can't seem to be able to locate the file, where can I find it?
> > > 
> > > thanks
> > > 
> > > Eial
> >
> > I apologize of the bump, can anyone help me on this subject?
> 
> As I read Documentation/kdump/kdump.txt kdump works in a different way,
> so it's a dead end. Does this panic happen on gentoo-sources or vanilla-sources?
> If it's on gentoo-sources, test vanilla (if it happens only on gentoo-sources
> then file a bug at http://bugs.gentoo.org).
> 
> No matter on which kernel it happens, you will have to write down an oops.
> You can take a picture of a screen with a camera.
> 
> And then read REPORTING-BUGS in kernel sources.
> 
> PS: Please don't top post.
> 
> Marcin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

after a while, I've managed to grab the panic, here is the image link: http://img207.imageshack.us/img207/2757/dscf6111.jpg
I think it is usb related.


