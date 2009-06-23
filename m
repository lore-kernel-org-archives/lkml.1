Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZFWNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZFWNJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZFWNJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:09:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZFWNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:09:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/2 v2] Blackfin: fix dma-mapping build errors
Date: Tue, 23 Jun 2009 15:07:45 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <20090623111430D.fujita.tomonori@lab.ntt.co.jp> <200906231040.46767.arnd@arndb.de> <8bd0f97a0906230409u5ec65e45je59cc2bea4852cde@mail.gmail.com>
In-Reply-To: <8bd0f97a0906230409u5ec65e45je59cc2bea4852cde@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906231507.45737.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18AeJmUcL5vBbK4ac25cR6SqCkcxsQCcQvINqo
 ykpOzoXxHLnjyR4PzPD6asAPEHGrh7e7gBWcmekZ9OmpqZWlji
 GRVLb8/UDiI1d2tOKsQxROrOoK3MdNy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Mike Frysinger wrote:
> i'll just integrate this into the patch you sent previously during the
> next merge window.  these new functions werent actually being used
> anywhere on Blackfin systems, so i'm not terribly worried about them
> for now.

Ok, fair enough.

	Arnd <><
