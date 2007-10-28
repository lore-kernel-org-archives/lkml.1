Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXJ1Oj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXJ1Oj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXJ1Ojs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:39:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60727 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXJ1Ojr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:39:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47249E8C.4070001@s5r6.in-berlin.de>
Date: Sun, 28 Oct 2007 15:37:00 +0100
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
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724557C.6000408@s5r6.in-berlin.de> <47247A1C.8010406@imap.cc>
In-Reply-To: <47247A1C.8010406@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 28.10.2007 10:25 schrieb Stefan Richter:
>> You two are hypothesizing.
> 
> No, we're not. We're discussing the very real issue of whether
> LSM should be amputated in such a way as to make life difficult
> for out of tree security module developers.

I still believe you are.  From what I understood, the API change had
technical reasons.  (What I have read is that using security modules in
the form of loadable and unloadable kernel modules didn't make sense.)
-- 
Stefan Richter
-=====-=-=== =-=- ===--
http://arcgraph.de/sr/
