Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYAIDdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYAIDdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYAIDda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:33:30 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36087 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752921AbYAIDd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:33:29 -0500
Message-ID: <399849620.27164@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 9 Jan 2008 11:33:32 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Sascha Warner <prx@cinatas.ath.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
References: <47742268.8040302@cinatas.ath.cx> <20071228150111.e9451632.akpm@linux-foundation.org> <47747B3A.5090304@cinatas.ath.cx> <200712291557.00585.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712291557.00585.hpj@urpla.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCRh6-0002fD-F8@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 03:56:59PM +0100, Hans-Peter Jansen wrote:
> Am Freitag, 28. Dezember 2007 schrieb Sascha Warner:
> > Andrew Morton wrote:
> > > On Thu, 27 Dec 2007 23:08:40 +0100 Sascha Warner <prx@cinatas.ath.cx> 
> wrote:
> > >> Hi,
> > >>
> > >> I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
> > >> pdflush often using 100% CPU for a long time. There seem to be some
> > >> rare pauses from its 100% usage, however.
> > >>
> > >> On ~23 minutes uptime i have ~19 minutes pdflush runtime.
> > >>
> > >> This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo
> > >> ~x64_64
> > >>
> > >> Let me know if you need more info.
> > >
> > > (some) cc's restored.  Please, always do reply-to-all.
> >
> > Hi Wu,
> 
> Sascha, if you want to address Fengguang by his first name, note that 
> chinese and bavarians (and some others I forgot now, too) typically use the 
> order:
>   
>   lastname firstname 
> 
> when they spell their names. Another evidence is, that the name Wu is a 
> pretty common chinese family name.
> 
> Fengguang, if it's the other way around, correct me please (and I'm going to 
> wear a big brown paper bag for the rest of the day..). 

You are right. We normally do "Fengguang" or "Mr. Wu" :-)
For LKML the first name is less ambiguous.

Thanks,
Fengguang

