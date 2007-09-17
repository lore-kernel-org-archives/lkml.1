Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXIQAau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXIQAau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 20:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXIQAan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 20:30:43 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3547 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXIQAam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 20:30:42 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <bunk@kernel.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Wasting our Freedom
Date: Sun, 16 Sep 2007 17:29:56 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEFKGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070916230936.GC18232@stusta.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 16 Sep 2007 17:30:37 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 16 Sep 2007 17:30:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk writes:

> On Sun, Sep 16, 2007 at 03:37:55PM -0700, David Schwartz wrote:

> > > Dual licenced code by definition explicitely states that you 
> > > can choose 
> > > the licence - otherwise it wouldn't be called dual-licenced.

> > You can choose under which license you would like to receive 
> > the right to modify or distribute the code. But you cannot change 
> > the license that code itself is covered by.
 
> You can choose the licence under which you distribute the code.

This is a misleading statement. When you distribute the code, you can choose from which license you obtain the right to distribute, but this has *NO* effect on the rights the recipient of the code gets.

This is a common misunderstanding, so people who understand the issue should work extra hard to be clear. If you obtain the right to distribute a dual-licensed work to me from the GPL, I still receive a dual-license to the work from the original author. You are not a party to the grant and cannot modify it.
 
> It's obvious that everyone else receiving the dual licenced code still 
> can choose for himself.

Everyone receiving dual-licensed code who wishes to modify or distribute that code may choose from which license they obtain that right. They need only comply with the terms of the license from which they obtain rights. But this has no effect on anybody else nor does it have any effect on what rights recipients get to that original work.

In every case, a recipient gets from the original author all the rights the original author offered to those elements that person authored.

> > Theo is right, you cannot choose the license on _this_ code. 
> > You can, of course, control the license on code that you 
> > contribute. Nothing prevents a derivative work from being under a 
> > different license from the original work.
 
> It would have helped if you would have read the email I gave a link to...
> 
> Theo was saying in his email:
> 
> <-- snip  -->
> 
> In http://lkml.org/lkml/2007/8/29/183, Alan Cox managed to summarize
> what Jiri Slaby and Luis Rodriguez were trying to do by proposing a
> modification of a Dual Licenced file without the consent of all the
> authors.  Alan asks "So whats the problem ?".  Well, Alan, I must
> caution you -- your post is advising people to break the law.
> 
> <--  snip  -->
> 
> Theo claims quite clearly that removing the BSD licence notice when 
> modifying BSD/GPL dual licenced code would break the law.

In responses and posts, there is over and over a huge confusion between two completely different issues. One is about whether you can modify licenses, the other is about whether you can modify license *notices*.

You can obtain the right to modify or remove a BSD license *notice* from the GPL. The GPL gives you the right to modify and doesn't require you to keep any *other* licenses intact. But this is simply a change to a notice. It has no effect on anyone's actual substantive rights whatsoever.

To the extent that others are saying that you cannot modify the *license*, they are correct. The original author extended that license to all recipients of their code, regardless of how they get them, and you cannot affect this process in any way.

Again, one more time:

1) You can obtain, from the GPL, the right to remove a BSD license notice.

2) You can obtain, from the BSD license, the right to remove a GPL license notice.

3) Neither of these actions has any effect on the fact that these licenses still exist from the original author and still grant rights to anyone who comes into lawful possession of the work.

Of course, if you take a dual-licensed file, remove the BSD notice, and then add more to it, those contributions can be offered *by* *their* *original* *authors* under only the GPL.

Any protectable elements still in the work that were offered by their original authors under either a dual-license or a BSD license are still licensed to every recipient of that derivative work under the original license. (See GPL section 6 and if you think it through, there's simply no other way it could work.)

> BTW: It is considered impolite on linux-kernel to remove Cc's.

Really? On almost every other forum I know of, the rule is the reverse. It is rude to CC posts to people who are most likely on the list anyway.

DS


