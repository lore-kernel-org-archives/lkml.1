Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbXJ1J0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbXJ1J0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 05:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXJ1J0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 05:26:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53070 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbXJ1J0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 05:26:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4724557C.6000408@s5r6.in-berlin.de>
Date: Sun, 28 Oct 2007 10:25:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Tilman Schmidt <tilman@imap.cc>, Greg KH <greg@kroah.com>,
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
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de>
In-Reply-To: <20071028005555.GC23339@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Oct 27, 2007 at 04:47:15PM +0200, Tilman Schmidt wrote:
>> There is a big difference between "not doing anything to help"
>> and "actively doing something to make life difficult for". The
>> former is undoubtedly legitimate. It's the latter we're
>> discussing here.
> 
> Justifying anything with code with not GPL compatible licences has zero 
> relevance here.
> 
> And there's value in making life harder for such modules with 
> questionable legality. As an example,
[...]

You two are hypothesizing.

  - We (most of us) change APIs to improve the kernel.

  - We (most of us) contribute to the kernel as a program for people to
    run, not as a library for other projects to develop different or
    extended kernels¹ on top of it.

Actually, by providing the code under GPL, full read access to the SCM
for everybody, and public development mailinglists, we make life for
external projects who do their own drivers and kernels as easy as these
unconnected projects could wish for.²

-----
¹) Even distributors of Linux kernel packages are encouraged to stay
close to mainline and to feed their changes into mainline, IOW to take
part in the Linux kernel project.

²) Of course if such projects chose to become part of the Linux kernel
project, they would get to enjoy additional bonuses as outlined at the
end of stable_api_nonsense.txt.  Sure, becoming part of the project
involves to cooperate, and not everybody wants or can afford to do so.
-- 
Stefan Richter
-=====-=-=== =-=- ===--
http://arcgraph.de/sr/
