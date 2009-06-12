Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZFLVmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZFLVmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbZFLVmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:42:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZFLVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:42:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] Blackfin: sync termios header changes with x86
Date: Fri, 12 Jun 2009 23:41:29 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200906121247.50745.arnd@arndb.de> <200906121329.33473.arnd@arndb.de> <8bd0f97a0906120435w16a1f46ewd9ad94ee35c04e6e@mail.gmail.com>
In-Reply-To: <8bd0f97a0906120435w16a1f46ewd9ad94ee35c04e6e@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906122341.30518.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18JN7hRtJg7JRcnaMAB6oYGz5tk6yrxNxdu5tk
 Y1yI9exu1sX4EKkqX7708Gy0FNPi330ztrUSWb/phd51gm7ri1
 CIxSOkr5Yk9dSsYDLnThQ5xAZvVM5Rz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Mike Frysinger wrote:
> > If you want a working version of this file, best copy it from avr32
> > or frv. Or just wait for the asm-generic version.
> 
> is asm-generic going to be in 2.6.31 ?  otherwise i'd prefer to have
> Blackfin fixed now rather than 2.6.32+

I certainly hope it does. I've sent the pull request yesterday,
so it's probably still in Linus' queue for trees to merge, unless
he dropped it.

	Arnd <><
