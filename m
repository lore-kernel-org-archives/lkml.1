Return-Path: <linux-kernel-owner+w=401wt.eu-S966252AbXBPJQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966252AbXBPJQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966253AbXBPJQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:16:56 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4874 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966252AbXBPJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:16:55 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Fri, 16 Feb 2007 01:16:44 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEDIBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <3d57814d0702152245q19e19141me0b999fb051ac7b6@mail.gmail.com>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 16 Feb 2007 01:17:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 16 Feb 2007 01:17:08 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll say that again, for everyone else who is reading this: the GPL
> makes it really clear that extensions to a GPL work are required to be
> distributed under the terms of the GPL.  All this junk about
> "derivative works" is just the legal jargon used to implement the
> intent of the GPL.  You can argue that a particular extension isn't a
> derivative work if you want, but you can't argue with the intent..
> cause it is written in plain english.

I don't think it was the intent of the GPL that if you want to make drivers
for a GPL'd operating system, you must make the drivers GPL'd. That seems
like precisely the sort of software-patent oligopoly (owning every way to do
a particular thing) that the GPL was intended to combat.

I quote from Stallman: "Nobody is trying to patent specific programs; that
isn't allowed, but nobody would bother even if it was allowed. A patent
covering one specific program would not really matter to anyone. The reason
why these patents create an issue is that they're not about specific
programs, they're much more general. Each of these patents covers an idea
that you might use in implementing various different programs, that lots of
different programmers might use, might put into the programs that they are
writing. And that's what makes them obstacles and dangers to software
development activity."

This is precisely what "every Linux driver is a derivative work of my work"
is saying. It is totally counter to the spirit and intent of the GPL.

Every time you say, "that's a derivative work and you need to follow the
rules", that's one less situation where you can say, "this is fair use" in
an analogous case with a commercial work. If closed source drivers are
against the spirit of the GPL, then it's not fair use to tinker with a
commercial work to get it to work with your hardware.

Most certainly the spirit of the GPL is that it's fair use to tinker with a
work to get it to work on your hardware. Is it not fair use to share that
with other licensees of the original work? Should Microsoft be able to
prevent me from distributing patches to Windows that fix bugs or add
features?

It is so funny that the GPL community is succumbing to the same desire to
expand intellectual property rights to get more control over their work that
they condemn in the closed source world. The open source community should be
trying to expand fair use, not expand derivative works.

In addition, it is quite clear legally that if you take only what every
attempt to perform the same function must take, you are not a derivative
work. That is, if you are writing a Linux driver for an X1950 graphics card,
you can take what any Linux driver for an X1950 graphics could would
reasonably need to take. (See, among other cases, Lexmark. v. Static
Controls.) A copyright is not a patent, you can only own something if there
are multiple equally good ways to do it and you claim *one* of them.

DS


