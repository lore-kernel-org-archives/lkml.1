Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbXF2JgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbXF2JgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXF2JgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:36:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:53473 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754239AbXF2JgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:36:07 -0400
Cc: linux-kernel@vger.kernel.org, rob@landley.net, davidsen@tmr.com
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 29 Jun 2007 11:36:03 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <4684C91B.5060203@ums.usu.ru>
Message-ID: <20070629093603.58490@gmx.net>
MIME-Version: 1.0
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru>
 <20070628161720.298550@gmx.net> <46843B9B.2080700@tmr.com>
 <20070629083021.58530@gmx.net> <4684C91B.5060203@ums.usu.ru>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX198fz8wfjJ8V8uos4KeAdDjSWbLeHozYIGuBFtW6b
 Q20M4c/heEoe+BaRU5bHuCO7ei68b/VoqPuA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 1Lf2Zr13eSEqQMf8EHUhB1l+IGRvb4BJ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, I think all that LFS seems to want is links that are
> > stable "for a while" (since I don't suppose that they want
> > to use really old tarballs in any case). So, for 
> > the benefit of LFS, I'll just be less aggressive about
> > moving tarballs into "Old" (I'll leave them sitting in
> http://www.kernel.org/pub/linux/docs/manpages/
> > for a few months at least.)
> 
> If this helps, here is the version information.
> 
> Stable LFS (version 6.2, released on August 3, 2006) tells users to
> download 
> man-pages 2.34 (two releases old at that time). LFS-6.3 is expected to be 
> released in two months or so, thus a one-year period before moving
> tarballs 
> to "Old" should be enough even for stable LFS books (and if we agree on 
> that, I'll close http://wiki.linuxfromscratch.org/lfs/ticket/2037 as
> invalid).
> 
> Thanks for cooperation.

Alex: Okay -- I've set up a script that ensures that
the "Archive" directory (was "Old") always includes links
to the latest versions of the pages, so you can be guaranteed
that links in Archive should always be stable (I don't know 
that I'll ever actually remove files from that directory).

Rob: the script also creates a LATEST-IS-m.xy file in 
/pub/linux/docs/manpages.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

