Return-Path: <linux-kernel-owner+w=401wt.eu-S1764363AbXF1QyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764363AbXF1QyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbXF1QyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:54:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:59182 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758948AbXF1QyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:54:06 -0400
Cc: rob@landley.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 28 Jun 2007 18:54:05 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <4683E2CB.8090100@ums.usu.ru>
Message-ID: <20070628165405.32040@gmx.net>
MIME-Version: 1.0
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru>
 <20070628161720.298550@gmx.net> <4683E2CB.8090100@ums.usu.ru>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/jO+s4MAHj/yuAMxxQbyaAwQYnJW4yxnDOhVyaqD
 reurAsn3U9Za/Us1Vl0OMLmxI3IQjYs1Dmug== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: mt+1d7Y/YmYBfZCoHnY3SHtCWkZTQVR1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Michael Kerrisk wrote:
> > How about a link in /pub/linux/docs/manpages/ of the form 
> > "LATEST-IS-m.xy"?  Rob Landley was wanting something like this,
> > and I guess it would be easy for LFS to build a simple
> > script that looks for that link and deduces "man-pages-m.xy" 
> > from it.  (I've just now created such a link in the directory,
> > as an example.)
> 
> We don't care about the latest version, so the link neither helps nor
> hurts us. What's needed is that the URL and the MD5 sum for a 
> version in the book 
> don't change, and that LFS developers have a reasonable time (say, two 
> weeks) to react to version updates. 

Don't change for how long?  As I said, old versions never were
available "forever" on kernel.org -- usually they only stayed a 
few months, though lately the lifetime stretched out a little.

I don't really want to, for example, copy the tarball to 
two places each time.  That takes me extra time, and is prone
to errors (e.g., I might forget).

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

