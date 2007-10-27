Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXJ0RcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXJ0RcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXJ0RcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:32:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33099 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXJ0RcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:32:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472375D5.5080107@s5r6.in-berlin.de>
Date: Sat, 27 Oct 2007 19:31:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Adrian Bunk <bunk@kernel.org>, Greg KH <greg@kroah.com>,
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
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc>
In-Reply-To: <47234F73.3040809@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote about:
> breaking interfaces they rely on for no other "very good
> reason" than to discourage out-of-tree development?

How often did this happen yet?
-- 
Stefan Richter
-=====-=-=== =-=- ==-==
http://arcgraph.de/sr/
