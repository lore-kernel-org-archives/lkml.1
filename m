Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYEXKbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYEXKbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 06:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYEXKav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 06:30:51 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:43615 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbYEXKau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 06:30:50 -0400
Date: Sat, 24 May 2008 05:11:06 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion About Kernel Releases
Message-ID: <20080524031106.GC12128@nibiru.local>
Reply-To: weigelt@metux.de
References: <48341ED5.7060508@netone.net.tr> <20080521063855.0bdb441c@infradead.org> <84144f020805210648y43efb024w8e2f28e62894b1d@mail.gmail.com> <48342B19.9040407@netone.net.tr> <170fa0d20805210732s24f2c188i75ab2ab2dab5aeb5@mail.gmail.com> <48343C92.4090403@netone.net.tr> <84144f020805210826p27c1892bxd84098371e209c1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020805210826p27c1892bxd84098371e209c1e@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> You keep saying that but it simply is not true. The more people we
> have _waiting_ for a "stable" kernel to graduate from the "testing"
> series, the less people we have actually _testing_ the kernel.

ACK.

I, personally use the newest releases on mostly unimportant 
systems, where a kernel bug is ugly but not that bad.
For production systems I use the stableized/well-tested distro
kernels, eg. unmasked on Gentoo). If you're using such an distro,
you already have an more tested kernel, less chance of bugs
(than with vanilla).

My suggestion istead is bringing these individual efforts from 
distros to some central point, let's call this "mature kernel".
This (IMHO) wouldn't affect the current development/release 
process, mission-critical systems can simply use that mature 
tree, and perhaps some pressure is taken from vanilla.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
