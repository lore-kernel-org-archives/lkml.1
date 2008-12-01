Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYLAAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYLAAyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYLAAyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:54:45 -0500
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:41843 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbYLAAyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:54:44 -0500
Date: Mon, 1 Dec 2008 01:51:42 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: scanner interface proposal was: [TALPA] Intro to a linux interface for on access scanning (fwd)
Message-ID: <20081201005142.GA27387@nibiru.local>
Reply-To: weigelt@metux.de
References: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm> <20081123223753.GA16424@nibiru.local> <20081123230306.48bc0274@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123230306.48bc0274@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ,
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42,
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida,
X-Killer: 23, endloesung, Weltuntergang,
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Fine. Why not just putting this into a userland filesystem ?
> 
> 1. Performance

Does it really hurt so bad, compared with all actual AV stuff ?
It has to go to userland anyway, in case you don't intend to 
put the scanner into the kernel ;-o

> 2. Networked file systems

What's the problem ?
(btw: 9P already *IS* an network filesystem ;-P)

> 3. Ioctls

Ah, just forgot a while that this crap still exists ;-o

BUT: do the affected dirs have to contain devices ? 
Is there any point for pulling /dev through the AV scanner ?


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
