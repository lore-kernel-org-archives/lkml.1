Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYFKSTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYFKSTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYFKST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:19:27 -0400
Received: from ufisa.uninett.no ([158.38.152.126]:56522 "EHLO ufisa.uninett.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYFKST0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:19:26 -0400
Date: Wed, 11 Jun 2008 20:19:20 +0200 (CEST)
From: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>
X-X-Sender: kolla@firda.kolla.no
To: Adrian Bunk <bunk@kernel.org>
cc: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>,
       geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: m68k: could the Apollo support possibly work?
In-Reply-To: <20080610174532.GD11685@cs181133002.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0806112002520.6449@firda.kolla.no>
References: <20080608190513.GE4048@cs181133002.pp.htv.fi> <alpine.LNX.1.10.0806101847490.26475@halbrend.uninett.no> <20080610174532.GD11685@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 1032 2008-04-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Adrian Bunk wrote:

> On Tue, Jun 10, 2008 at 06:48:34PM +0200, Kolbjørn Barmen wrote:
> > On Sun, 8 Jun 2008, Adrian Bunk wrote:
> > 
> > > Does anyone still have this hardware and tried booting it in recent years?
> > 
> > I think I might borrow one from some NetBSD people, if I ask really really
> > nicely :)
> 
> AFAIR NetBSD doesn't support the Apollos.

OK, I was (and still is) somewhat confused about the defintion of "apollo" :)

What NetBSD does support is the so called hp300, the Apollo DNXXXXX is not
supported, allthough there appearantly a guy "working" on it every now and
then.  http://netbsd.pair.com/Ports/hp300/ 

What definition of Apollo are we talking about in Linux/m68k context?
I thought it was http://www.tazenda.demon.co.uk/phil/linux-hp/ which
actuall is hp300, from what I can tell.

> Do you plan to work on getting the Linux support back into shape?

Heh, no, I was just saying that I might try to boot one :)


-- kolla
