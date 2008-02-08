Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYBHW6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYBHW6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYBHW6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:58:32 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48724 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYBHW6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:58:31 -0500
Date: Fri, 8 Feb 2008 23:58:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: ael <law_ence.dev@ntlworld.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: git tree urls
In-Reply-To: <foild8$cnr$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0802082353390.26116@fbirervta.pbzchgretzou.qr>
References: <foheti$vgb$1@ger.gmane.org> <Pine.LNX.4.64.0802082014150.26116@fbirervta.pbzchgretzou.qr>
 <foild8$cnr$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2008 22:34, ael wrote:
>Jan Engelhardt wrote:
>> On Feb 8 2008 11:37, ael wrote:
>>> I have trouble locating some of the git urls (the mm repository, for
>>> example). I have browsed around
>>> http://www.kernel.org/pub/scm/linux/kernel/git/,
>>> consulted the kernel FAQ, and read the obvious links on www.kernel.org.
>>>
>>> git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.x.y.git is easy
>>> to find, and I would guess that the main development repository is
>>> pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
>>> but that is speculation.
>> 
>> Look at http://git.kernel.org/ for available repositories.
>
>Sure, I looked there in some depth. But some/most are special purpose or
> 'locals'. One needs a map for the "main" repositories...

Indeed, a page on kernelnewbies.org with the most important repositories
would be helpful.

Well, to start:

torvalds/linux-2.6.git	Mainline
jgarzik/netdev-2.6.git	Network devices
davem/net-2.6.git	Networking
x86/linux-2.6-x86.git	x86
mchehab/v4l-dvb.git	V4L and DVB
bunk/trivial.git	Spellos, typos and the obvious

But it's not that easy. netdev-2.6.git for example regularly gets merged
into net-2.6.git, so you get a fairly recent netdev tree by choosing
either netdev or net.
