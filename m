Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbXJ3Ikq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbXJ3Ikq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXJ3Ikd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:40:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51591 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbXJ3Ikb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:40:31 -0400
Date: Tue, 30 Oct 2007 09:40:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Toshiharu Harada <haradats@nttdata.co.jp>
cc: casey@schaufler-ca.com, Chris Wright <chrisw@sous-sol.org>,
       Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
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
In-Reply-To: <4726A3A2.7060205@nttdata.co.jp>
Message-ID: <Pine.LNX.4.64.0710300936500.31325@fbirervta.pbzchgretzou.qr>
References: <183239.5113.qm@web36604.mail.mud.yahoo.com> <4726A3A2.7060205@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30 2007 12:23, Toshiharu Harada wrote:
>
> Instead of pushing TOMOYO Linux, I started developing
> comparison chart of security-enhance Linux implementations.
> The current version can be found in
>
> http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison

Smack Security Model: autolabel, as far as I can tell.
Smack Policy Generation: user - hand - and an editor
Apparmor tutorial (beats any FAQ at first):
	ftp://ftp.belnet.be/pub/mirror/FOSDEM/FOSDEM2006-apparmor.avi
