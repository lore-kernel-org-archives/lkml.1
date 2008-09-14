Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYINDoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYINDoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 23:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYINDoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 23:44:03 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:47230 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbYINDoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 23:44:01 -0400
Subject: Re: [linux-dvb] Multiproto API/Driver Update
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, linux-dvb@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	 <48C66829.1010902@grumpydevil.homelinux.org>
	 <d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	 <48CC42D8.8080806@gmail.com>
	 <d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 14 Sep 2008 05:39:57 +0200
Message-Id: <1221363597.2667.2.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Sonntag, den 14.09.2008, 00:56 +0200 schrieb Markus Rechberger:
> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> > Markus Rechberger wrote:
> >
> >> How many devices are currently supported by the multiproto API
> >> compared with the s2 tree?
> >
> > The initial set of DVB-S2 multistandard devices supported by the
> > multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
> > alone. There are more additions by 2 more modules (not devices), but for
> > the simple comparison here is the quick list of them, for which some of
> > the manufacturers have shown support in some way. (There has been quite
> > some contributions from the community as well.):
> >
> > (Also to be noted is that, some BSD chaps also have shown interest in
> > the same)
> >
> 
> they're heavy into moving the whole framework over as far as I've seen
> yes, also including yet unmerged drivers.

:) any problems?

> > * STB0899 based
> >
> > Anubis
> > Typhoon DVB-S2 PCI
> >
> > Azurewave/Twinhan
> > VP-1041
> > VP-7050
> >
> > Digital Now
> > AD SP400
> > AD SB300
> >
> > KNC1
> > TV Station DVB-S2
> > TV Station DVB-S2 Plus
> >
> > Pinnacle
> > PCTV Sat HDTV Pro USB 452e
> >
> > Satelco
> > TV Station DVB-S2
> > Easywatch HDTV USB CI
> > Easywatch HDTV PCI
> >
> > Technisat
> > Skystar HD
> > Skystar HD2
> > Skystar USB2 HDCI
> >
> > Technotrend
> > TT S2 3200
> > TT S2 3600
> > TT S2 3650
> >
> > Terratec
> > Cinergy S2 PCI HD
> > Cinergy S2 PCI HDCI
> >
> 
> those are pullable now against the current tree?
> 
> Markus
> 


