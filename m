Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbXJYBp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbXJYBp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXJYBpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:45:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47607 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753411AbXJYBpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:45:15 -0400
Date: Thu, 25 Oct 2007 02:41:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Chris Wright" <chrisw@sous-sol.org>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
 static interface)
Message-ID: <20071025024131.6082e4a8@the-village.bc.nu>
In-Reply-To: <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
References: <20071024223124.GI30533@stusta.de>
	<446110.89443.qm@web36608.mail.mud.yahoo.com>
	<20071025002356.GB3660@sequoia.sous-sol.org>
	<2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The idea that poor security is worse than no security is fallacious,
> and not backed up by common experience.

There is a ton of evidence both in computing and outside of it which
shows that poor security can be very much worse than no security at all.
In particular stuff which makes users think they are secure but is
worthless is very dangerous indeed.

When you know that security is limited you act appropriately, when you
believe security is good but it is not you take inappropriate risks and
get badly burned.

Alan
