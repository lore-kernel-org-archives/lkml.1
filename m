Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXIBA7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXIBA7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXIBA7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:59:38 -0400
Received: from mx1.dixongroup.net ([38.98.104.248]:44841 "EHLO
	mx1.dixongroup.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbXIBA7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:59:36 -0400
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 20:59:36 EDT
In-Reply-To: <20070901215225.GM9260@stusta.de>
References: <200709010140.l811eq9H005896@cvs.openbsd.org> <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com> <46D99FB7.6030505@garzik.org> <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com> <20070901205457.GK9260@stusta.de> <f34ca13c0709011427u <20070901215225.GM9260@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3A831845-B630-42AD-B52F-DC9EA2060BAE@dixongroup.net>
Cc: mureninc@gmail.com, jeff@garzik.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk
Content-Transfer-Encoding: 7bit
From: Jason Dixon <jason@dixongroup.net>
Subject: Re: That whole "Linux stealing our code" thing
Date: Sat, 1 Sep 2007 20:36:24 -0400
To: bunk@kernel.org
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 1, 2007, at 5:52 PM, Adrian Bunk wrote:

> OK, I begin to understand this, there seem to be three different types
> of files changed by Jiri's patch:
> 1. dual licenced files planned to make GPL-only
> 2. previously dual licenced files with a too recent version used  
> planned
>    to make GPL-only
> 3. never dual licenced files planned to make GPL-only
>
> For files under 1. and 2. Reyk did contribute to dual licenced code
> without touching the licence, but I missed that there's also code  
> unter 3.
>
> So there is a problem, but not with the code under 1. (unless you plan
> to change the semantics of the word "alternatively"), the problem is
> with some headers under 2. plus the code under 3.

The BSD license plainly states:

"Permission to use, copy, modify, and/or distribute this software for  
any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies."

Once the grantor (Reyk) releases his code under that license, it must  
remain.  You are free to derive work and redistribute under your  
license, but the original copyright and license permission remains  
intact.  Many other entities (Microsoft, Apple, Sun, etc) have used  
BSD code and have no problem understanding this.  Why is this so  
difficult for the Linux brain share to absorb?

As a former Linux advocate and current OpenBSD user/developer, I'm  
appalled that fellow open-source developers would see fit to  
cavalierly disregard the rights of the original copyright holder.   
You wield the GPL when it suits you, and trample the courtesies of  
non-GPL developers just because you [think you] can.  As bad as  
Jiri's offense was, it pales to the impudence displayed by Alan Cox,  
one of the so-called defenders of free software.

Shame on you all.

---
Jason Dixon
DixonGroup Consulting
http://www.dixongroup.net


