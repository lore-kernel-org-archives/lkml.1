Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXFBHnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXFBHnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXFBHn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:43:29 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:51010 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbXFBHn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:43:29 -0400
Date: Sat, 2 Jun 2007 09:45:26 +0200
From: DervishD <lkml@dervishd.net>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070602074526.GC20145@DervishD>
Mail-Followup-To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <46604928.4050002@ums.usu.ru> <46604C31.2070009@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46604C31.2070009@ums.usu.ru>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Alexander :)

 * Alexander E. Patrakov <patrakov@ums.usu.ru> dixit:
> >The switch is possible. You could try the latest development LFS LiveCD 
> >(http://ums.usu.ru/~patrakov/test/lfslivecd-x86-6.3-pre2-r1897.iso) and 
> >see if it works for you (be sure to CC: me if you post any feedback).
> 
> I was wrong. The problem is that input works, output works, but 
> copying-and-pasting with gpm doesn't work (the stable version of the CD, 
> http://ums.usu.ru/~patrakov/x86/lfslivecd-x86-6.2-5.iso, contains a 
> rejected-upstream kernel patch that hides the issue). This means that for 
> all serious Unicode work, you must use X.

    Not a problem for me because I don't use GPM. I hate mice, and while
under X I'm forced (more or less) to use them, I don't use a mouse on
the console. I can blind type, so I prefer to keep my hands on the
keyboard. I work much more fast that way, and I haven't needed to copy
and paste between consoles ever.

    Thanks anyway for the warning ;)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
