Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbYAHPMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbYAHPMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYAHPLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:11:51 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36001 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754697AbYAHPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:11:50 -0500
Date: Tue, 8 Jan 2008 16:11:48 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Geoff Levand <geoffrey.levand@am.sony.com>, linux-kernel@vger.kernel.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [announce] PS3 Linux Distributor's Starter Kit
 (v1.5.1) released
In-Reply-To: <1198372695.11901.92.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0801081610490.3855@vixen.sonytel.be>
References: <4581CA0C.20102@am.sony.com>  <476C3285.2060502@am.sony.com>
 <1198372695.11901.92.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-301861140-1199805108=:3855"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-301861140-1199805108=:3855
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 23 Dec 2007, David Woodhouse wrote:
> On Fri, 2007-12-21 at 13:39 -0800, Geoff Levand wrote:
> > An updated kboot image is here:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/geoff/cell/kboot-20071220.bld
> 
> NFS booting seems to fail. After saying 'Mounting ...' for 30 seconds or
> so, it then says 'rpcbind: server 0.0.0.0 not responding, timed out'.

Do you mean booting the second stage kernel with NFS root? Or something
different?

I've just booted a kernel using TFTP and NFS root from this kboot without
any problems.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-301861140-1199805108=:3855--
