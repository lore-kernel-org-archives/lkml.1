Return-Path: <linux-kernel-owner+w=401wt.eu-S1765479AbXJZHRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765479AbXJZHRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764773AbXJZHJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 03:09:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52863 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763398AbXJZHJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 03:09:08 -0400
Date: Fri, 26 Oct 2007 09:09:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: Tilman Schmidt <tilman@imap.cc>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <20071026025647.GC21408@kroah.com>
Message-ID: <Pine.LNX.4.64.0710260908290.25696@fbirervta.pbzchgretzou.qr>
References: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
 <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org>
 <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org>
 <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de>
 <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de>
 <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25 2007 19:56, Greg KH wrote:
>
>I'm trying to compile a list of all known external modules and drivers
>and work to get them included in the main kernel tree to help prevent
>these kinds of things.  If you know of any that are not on the list at:
>	http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>please feel free to add them, or email me with the needed information
>and I will add them to the list.

Do I have to at least try to submit it to LKML first before it is
even considered for the OOT wiki page? :-)
