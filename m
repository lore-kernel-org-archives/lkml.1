Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXJ3NUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXJ3NUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXJ3NUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:20:33 -0400
Received: from smtp27.orange.fr ([80.12.242.94]:4709 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbXJ3NUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:20:31 -0400
X-ME-UUID: 20071030132029891.D99631C00095@mwinf2701.orange.fr
Subject: Re: eradicating out of tree modules
From: Xavier Bestel <xavier.bestel@free.fr>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <greg@kroah.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0710300802100.13303@chaos.analogic.com>
References: <20071024125533.GE30533@stusta.de>
	 <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de>
	 <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com>
	 <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de>
	 <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de>
	 <4724DA20.1010609@imap.cc> <20071028192528.GF7227@stusta.de>
	 <47267ADD.2030202@imap.cc>
	 <Pine.LNX.4.61.0710300802100.13303@chaos.analogic.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 14:19:28 +0100
Message-Id: <1193750368.21628.28.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 09:11 -0400, linux-os (Dick Johnson) wrote:
> I'm sure that the majority of Linux users would never acquire
> the 4-board assembly that we use to acquire X-Ray data and
> generate real-time images for the baggage scanners in use
> at the world's major airports. That assembly, containing
> numerous CPUs and other high-speed pipelined stuff would
> cost the user about  US$100,000 so I'm pretty sure that
> are not many takers so it is very unlikely that any modules
> to support it would never get into the mainstream kernel.

As long as you're maintaining them proprely, I don't why.

	Xav


