Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbYJRWjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbYJRWjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJRWiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:38:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44707 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJRWiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:38:54 -0400
Date: Sat, 18 Oct 2008 18:38:53 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Greg KH <greg@kroah.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Noonan <steven@uplinklabs.net>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <20081017214409.GB3585@kroah.com>
Message-ID: <alpine.LNX.1.10.0810181836260.27947@fbirervta.pbzchgretzou.qr>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi>
 <2008101 <20081017214409.GB3585@kroah.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-10-17 17:44, Greg KH wrote:
>
>Sure, but by then, the 2.6.521 release will be out and we could fix it
>up by finally going to 3.0 :)

There will be no 2.6.521. Simply because the LINUX_VERSION_CODE
macro only allows for the 2nd and 3rd position to be 8 bits.

(Hooray, which means we will _automatically_ get a 2.7 after at most
229 more releases, or 3.0 after at most 63973 more releases!^{*})


{*} If you find off-by-one errors, keep them.
