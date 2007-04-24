Return-Path: <linux-kernel-owner+w=401wt.eu-S1031002AbXDXA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031002AbXDXA4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031006AbXDXA4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:56:39 -0400
Received: from koto.vergenet.net ([210.128.90.7]:37662 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031002AbXDXA4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:56:39 -0400
Date: Tue, 24 Apr 2007 09:56:35 +0900
From: Simon Horman <horms@verge.net.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: fastboot@lists.osdl.org, Vivek Goyal <vgoyal@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Haren Myneni <hbabu@us.ibm.com>
Subject: Re: Update the list information for kexec and kdump
Message-ID: <20070424005634.GD11736@verge.net.au>
References: <20070423083936.GI4272@verge.net.au> <m13b2rvuge.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13b2rvuge.fsf@ebiederm.dsl.xmission.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 12:04:01PM -0600, Eric W. Biederman wrote:
> Simon Horman <horms@verge.net.au> writes:
> 
> > Update the list information for kexec and kdump
> >
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> >
> > --- 
> > Is it too early for this change?
> 
> It looks like the new list is working, and isn't likely to get overwhelmed
> with spam.  I don't know if everyone has switched over yet but we can
> certainly update MAINTAINERS. 

Last time I checked there were 28 people in the kexec@ list.
This isn't everyone, but it is getting there.

May I add an Acked-by you ?

> Eric
> 
> > Index: linux-2.6/MAINTAINERS
> > ===================================================================
> > --- linux-2.6.orig/MAINTAINERS	2007-04-23 17:34:30.000000000 +0900
> > +++ linux-2.6/MAINTAINERS	2007-04-23 17:34:47.000000000 +0900
> > @@ -1951,7 +1951,7 @@ P:	Vivek Goyal
> >  M:	vgoyal@in.ibm.com
> >  P:	Haren Myneni
> >  M:	hbabu@us.ibm.com
> > -L:	fastboot@lists.osdl.org
> > +L:	kexec@lists.infradead.org
> >  L:	linux-kernel@vger.kernel.org
> >  W:	http://lse.sourceforge.net/kdump/
> >  S:	Maintained
> > @@ -2001,7 +2001,7 @@ P:	Eric Biederman
> >  M:	ebiederm@xmission.com
> >  W:	http://www.xmission.com/~ebiederm/files/kexec/
> >  L:	linux-kernel@vger.kernel.org
> > -L:	fastboot@lists.osdl.org
> > +L:	kexec@lists.infradead.org
> >  S:	Maintained
> >  
> >  KPROBES

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

