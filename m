Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbXJZQAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbXJZQAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXJZP7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:59:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56985 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXJZP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:59:40 -0400
Date: Fri, 26 Oct 2007 08:54:15 -0700
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071026155415.GE23016@kroah.com>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <Pine.LNX.4.64.0710260908290.25696@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710260908290.25696@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 09:09:05AM +0200, Jan Engelhardt wrote:
> 
> On Oct 25 2007 19:56, Greg KH wrote:
> >
> >I'm trying to compile a list of all known external modules and drivers
> >and work to get them included in the main kernel tree to help prevent
> >these kinds of things.  If you know of any that are not on the list at:
> >	http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
> >please feel free to add them, or email me with the needed information
> >and I will add them to the list.
> 
> Do I have to at least try to submit it to LKML first before it is
> even considered for the OOT wiki page? :-)

No, you can go hide on your own, that's what the majority of projects on
that page have done :)

But of course, it would be good for you to at least submit it and get
feedback.  Or, if you don't want to do it, the linuxdriverproject
developers would be glad to help you out...

thanks,

greg k-h
