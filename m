Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYH0Lk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYH0Lk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYH0LkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:40:13 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55678 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754957AbYH0LkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:40:12 -0400
Date: Wed, 27 Aug 2008 13:40:10 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: Kevin Diggs <kevdig@hypersurf.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add cpufreq driver for the IBM PowerPC 750GX
In-Reply-To: <200808271334.16712.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0808271339230.22151@vixen.sonytel.be>
References: <48B28F23.1000906@hypersurf.com> <200808261329.22699.arnd@arndb.de>
 <48B51A31.8090909@hypersurf.com> <200808271334.16712.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1757792643-1219837210=:22151"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1757792643-1219837210=:22151
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 27 Aug 2008, Arnd Bergmann wrote:
> On Wednesday 27 August 2008, Kevin Diggs wrote:
> > Arnd Bergmann wrote:
> > > Are there even SMP boards based on a 750? I thought only 74xx
> > > and 603/604 were SMP capable.
> > > 
> > Not that I have heard of. I thought it was lacking some hardware that
> > was needed to do SMP? Can the 603 do SMP?
> 
> No, I was wrong about the 603. The machine I was thinking of is actually
> 604e.

The BeBox had a dual 603.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1757792643-1219837210=:22151--
