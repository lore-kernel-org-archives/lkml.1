Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbXL2O6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbXL2O6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 09:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXL2O55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 09:57:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:50476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbXL2O55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 09:57:57 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: Sascha Warner <prx@cinatas.ath.cx>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
Date: Sat, 29 Dec 2007 15:56:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       WU Fengguang <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <47742268.8040302@cinatas.ath.cx> <20071228150111.e9451632.akpm@linux-foundation.org> <47747B3A.5090304@cinatas.ath.cx>
In-Reply-To: <47747B3A.5090304@cinatas.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712291557.00585.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+tXqo8o/nyyXHEXrVeMw6gInbtxo5toQLWSsh
 lsVUevZjdaEfO0smU6KuyntRIiHxOaugFLYuiPyO6uKxiHDF6D
 /tljc5Q0zClVcVsrSJ3KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 28. Dezember 2007 schrieb Sascha Warner:
> Andrew Morton wrote:
> > On Thu, 27 Dec 2007 23:08:40 +0100 Sascha Warner <prx@cinatas.ath.cx> 
wrote:
> >> Hi,
> >>
> >> I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
> >> pdflush often using 100% CPU for a long time. There seem to be some
> >> rare pauses from its 100% usage, however.
> >>
> >> On ~23 minutes uptime i have ~19 minutes pdflush runtime.
> >>
> >> This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo
> >> ~x64_64
> >>
> >> Let me know if you need more info.
> >
> > (some) cc's restored.  Please, always do reply-to-all.
>
> Hi Wu,

Sascha, if you want to address Fengguang by his first name, note that 
chinese and bavarians (and some others I forgot now, too) typically use the 
order:
  
  lastname firstname 

when they spell their names. Another evidence is, that the name Wu is a 
pretty common chinese family name.

Fengguang, if it's the other way around, correct me please (and I'm going to 
wear a big brown paper bag for the rest of the day..). 

> Your latest patch does fix the seen pdflush 100% issue :)
>
> P.S.: Andrew, sorry my subject pretended I was subscribed to lkml, I am
> not. I hoped for the script at lkml to pull the threads together because
> of the subject.

Such a script _cannot_ exist for a mailing list. Sane mailing list software 
mangles messages in the least intrusive way and highly depend on users 
doing the right thing. In this case, that's what Sam suggested below!

A-happy-new-year-for-all-kernel-hacking-heros-ly-yrs,

Pete
