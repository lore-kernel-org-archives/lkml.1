Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZI0TAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZI0TAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZI0TAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:00:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1233 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbZI0TAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:00:43 -0400
Subject: Re: [PATCH 1/3] lib/vsprintf.c: Add %pU - ptr to a UUID/GUID
From: Joe Perches <joe@perches.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <200909271245.34000.ioe-lkml@rameria.de>
References: <cover.1254030722.git.joe@perches.com>
	 <1507728e0ea3deafa71c481d508a6e9765c92221.1254030722.git.joe@perches.com>
	 <200909271245.34000.ioe-lkml@rameria.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Sep 2009 12:00:46 -0700
Message-Id: <1254078046.28232.183.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 12:45 +0200, Ingo Oeser wrote:
> Hi Joe,

Hello Ingo.

> On Sunday 27 September 2009, Joe Perches wrote:
> > UUID/GUIDs are somewhat common in kernel source.
> > Standardize the printed style of UUID/GUIDs by using
> > another extension to %p.
> > %pU:    01020304:0506:0708:090a:0b0c0d0e0f10
> > %pUr:   04030201:0605:0807:0a09:0b0c0d0e0f10
> Code does "01020304-0506-0708-090a-0b0c0d0e0f10".
> This is not, what commit promises. Please change the commit message!

True enough, that can change, no worries.

Does anyone have comments like:

1 what a stupid idea
2 how unnecessary
3 meh
4 bloat alert! linux is supposed to be lean
5 ok idea, bad implementation
6 sure, why not

