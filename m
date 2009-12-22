Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZLVJI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZLVJI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 04:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLVJI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 04:08:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:33879 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751139AbZLVJIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 04:08:25 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1918XpeUqd1lWb2Af+otN0ut1dOrGpA1iHO30dM2n
	cornMI5TEToT5k
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 1/6] uwb/i1480: add __init/__exit macros
Date: Tue, 22 Dec 2009 10:08:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: David Vrabel <david.vrabel@csr.com>, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de> <1261471904.609.0.camel@localhost.localdomain> <200912220957.25680.PeterHuewe@gmx.de>
In-Reply-To: <200912220957.25680.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912221008.24319.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 22 Dezember 2009 09:57:25 schrieb Peter Hüwe:
> Am Dienstag 22 Dezember 2009 09:51:44 schrieb Marcel Holtmann:
> > Hi Peter,
> >
> > > Trivial patch which adds the __init/__exit macros to the module_init/
> > > module_exit functions of
> > >
> > > uwb/i1480/i1480-est.c
> > >
> > > @Jiri: As there is no maintainer, it seems it is up to you to decide :)
> >
> > actually David Vrabel is taking care of the UWB subsystem and everything
> > related to it.
> >
> > Regards
> >
> > Marcel
> 
> Hmm, okay - thanks for the hint.
> 
> Unfortunately get-maintainers.pl did not come up with any one.
> 
> Thanks,
> Peter

Created a patch for MAINTAINERS
"[PATCH] MAINTAINERS: Fix entry for uwb to include subdirectories"


Thanks,
Peter
