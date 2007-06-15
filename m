Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbXFOQWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbXFOQWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXFOQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:22:39 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:55179 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbXFOQWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:22:38 -0400
Date: Fri, 15 Jun 2007 18:22:53 +0200
From: DervishD <lkml@dervishd.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070615162253.GD2373@DervishD>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <466D379C.6000809@wpkg.org> <20070614163803.GA31984@lazybastard.org> <467178B9.5070302@wpkg.org> <20070614174647.GC31984@lazybastard.org> <20070614224646.GE1928@DervishD> <20070615120859.GD6791@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070615120859.GD6791@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jörn :)

 * Jörn Engel <joern@logfs.org> dixit:
> On Fri, 15 June 2007 00:46:46 +0200, DervishD wrote:
> >     When do you think it will be included mainstream?
> 
> I am horrible at predictions, doubly so when concerning the future.
> 
> Several people believe it is good enough for -mm inclusion now.  So it
> might make it for 2.6.23 or 2.6.24.

    I don't really give a heck about that, because I will be using that
pendrive only in my system, but I think that pendrives are pretty common
nowadays, and using FAT with them is a waste. I don't like losing my
metadata just because I have to copy my data on a pendrive. So it's good
to see this filesystem mainstream'ed, it will be very good for small
distros (specially now that most of mobos allow booting from USB
sticks).

    A pity that my digital camera won't want to use LogFS :((

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
