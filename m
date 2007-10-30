Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXJ3Phq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXJ3Phq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXJ3Ph3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:37:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55010 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbXJ3Ph2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:37:28 -0400
Date: Tue, 30 Oct 2007 08:30:36 -0700
From: Greg KH <greg@kroah.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: eradicating out of tree modules
Message-ID: <20071030153036.GA22501@kroah.com>
References: <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724DA20.1010609@imap.cc> <20071028192528.GF7227@stusta.de> <47267ADD.2030202@imap.cc> <Pine.LNX.4.61.0710300802100.13303@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0710300802100.13303@chaos.analogic.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 09:11:11AM -0400, linux-os (Dick Johnson) wrote:
> I'm sure that the majority of Linux users would never acquire
> the 4-board assembly that we use to acquire X-Ray data and
> generate real-time images for the baggage scanners in use
> at the world's major airports. That assembly, containing
> numerous CPUs and other high-speed pipelined stuff would
> cost the user about  US$100,000 so I'm pretty sure that
> are not many takers so it is very unlikely that any modules
> to support it would never get into the mainstream kernel.

Of course it would be accepted, hell, we have a whole sub-architecture
with what, 3 users?  :)

So please submit patches for your drivers, and we will be glad to review
them.

thanks,

greg k-h
