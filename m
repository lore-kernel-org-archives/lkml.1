Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXJ0OH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXJ0OH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXJ0OHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:07:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59063 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbXJ0OHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:07:47 -0400
X-Sasl-enc: 65I/76i4T8pr3bMQKDAoENXz5KI1fRPZFdVMTAz/EFBt 1193494066
Message-ID: <4723462D.2010002@imap.cc>
Date: Sat, 27 Oct 2007 16:07:41 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
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
Subject: eradicating out of tree modules (was: Linux Security *Module* Framework)
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026155833.GF23016@kroah.com>
In-Reply-To: <20071026155833.GF23016@kroah.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH schrieb:
> On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
>> [...] I still think there will always be
>> a number of external modules that cannot be merged right now or at
>> all, and deliberately making life difficult for out-of-tree code
>> maintainers in order to coerce them into submitting their code for
>> inclusion in the kernel will not work, it'll only create bad
>> feelings.
> 
> Do you have examples of proof of this?

No proof in the legal, mathematical or scientific sense of the
term, but examples:

- at least one talented kernel developer giving up his work,
until then maintained out of tree, after submitting it for
inclusion in the kernel and taking the ensuing fla^Wdiscussion
on LKML (nothing extraordinary, just the usual lack of
courtesy and respect) too much to heart

- the furious flames on LKML each time someone dares posting
helpful information about getting non-GPL software working
again with the newest kernel version, which will certainly
never achieve inclusion of that software in the kernel but
definitely create bad feelings on both sides (righteous
indignation *is* a bad feeling in my book)

>  Read Documentation/stable_api_nonsense.txt for how we already make
> out-of-tree code developer's lives hell :)

Oh yes, that one. A key piece of evidence. Yes, I've read it,
though I sometimes wish I hadn't. Its very title supports my
observation on the creation of bad feelings, and the actual
text doesn't contradict it. (no ":)")

T.

