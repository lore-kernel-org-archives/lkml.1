Return-Path: <linux-kernel-owner+w=401wt.eu-S1767700AbXEDHyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767700AbXEDHyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767709AbXEDHyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:54:22 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34933 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767700AbXEDHyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:54:21 -0400
Date: Fri, 4 May 2007 09:53:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Willy Tarreau <w@1wt.eu>
cc: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
In-Reply-To: <20070504001147.GA31125@1wt.eu>
Message-ID: <Pine.LNX.4.61.0705040947170.18504@yvahk01.tjqt.qr>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
 <20070503205341.GB943@1wt.eu> <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
 <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
 <20070503222334.GD943@1wt.eu> <Pine.LNX.4.61.0705040049520.18504@yvahk01.tjqt.qr>
 <20070504001147.GA31125@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 02:11, Willy Tarreau wrote:
>> 
>> Haha. Would you be happy if it ran on a CF card instead? :>
>
>Yes, because at least when you design a system to run on a CF card, you
>ensure never to write on it because you know that would kill it. Then
>since you never write on it, it does not wear out and has no problem
>running for years (unless you bought cheap end-user CF of course).

Funny, I just installed a 'full' Linux distro on a CF, like with a
regular harddisk, and it runs in full rw mode. Packing it up in a
squashfs and running the thing with aufs did not seem worth
the hassle of setting up a specialized initrd. And then, when you
need to make one change (firewall), it's faster than recreating the
sqfs image.
Will see how it long that lasts.


Jan
-- 
