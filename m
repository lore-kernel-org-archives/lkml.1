Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZD0Kup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZD0Kup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZD0Kuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:50:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZD0Kuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:50:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 01/30] microblaze_mmu_v1: Makefiles
Date: Mon, 27 Apr 2009 12:50:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1240821139-7247-2-git-send-email-monstr@monstr.eu>
In-Reply-To: <1240821139-7247-2-git-send-email-monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271250.26725.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ZR13RkiQ5cpTC8P2ii7s8rARxZMnu7Y3IVpH
 lpncGEM2Fu3XFy+ZIWYU8jLc3sv+FE/FDjlevOxlTuFR4YKELa
 KCYHX2L5sIczK1kycbftQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/Makefile        |    4 ++++
>  arch/microblaze/boot/Makefile   |    2 ++
>  arch/microblaze/kernel/Makefile |    1 +
>  arch/microblaze/lib/Makefile    |    3 ++-
>  arch/microblaze/mm/Makefile     |    2 ++
>  5 files changed, 11 insertions(+), 1 deletions(-)

It would be nice to keep the Makefile and Kconfig changes together with
the files they are referring to, otherwise you risk getting an
unbuildable source tree in the middle of a git-bisect.

	Arnd <><
