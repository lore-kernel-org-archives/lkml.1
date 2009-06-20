Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZFTUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZFTUtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZFTUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:49:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZFTUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:49:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH -tip RESEND] x86: asm/termios.h remove irrelevant comment for userspace
Date: Sat, 20 Jun 2009 22:49:12 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
References: <1245314365.31204.7.camel@ht.satnam> <1245347157.2481.14.camel@ht.satnam> <1245530761.2459.3.camel@ht.satnam>
In-Reply-To: <1245530761.2459.3.camel@ht.satnam>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906202249.13928.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18XtWwO92fyYj1yNrYM6DyxlPQCT3GJsSNOWSL
 42XyEIjX6ATjBhdnWoCqoRtXkz7cuUOg64bgZdjk4+txjF4pfr
 TVAa/2MZkfZnBhdNE5v+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 June 2009, Jaswinder Singh Rajput wrote:
> 
> following comment is irrelevant at usr/include/asm/termios.h :
> 
> "ioctl (fd, TIOCSERGETLSR, &result) where result may be as below"
> 
> Also fixed some alignment and space issues.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

that file just got removed in tip.

	Arnd <><
