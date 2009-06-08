Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZFHItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZFHItj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZFHItb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:49:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZFHIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:49:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 8 Jun 2009 10:49:22 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200906041747.04310.arnd@arndb.de> <200906081003.59171.arnd@arndb.de> <20090608172200A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090608172200A.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906081049.23045.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18keIlpThKVn+Xda4SnJd9Dr6H9o60dzAV24yu
 GwuiDhscHAtbksPlwed2ItG/Fm2ekLayNj5AUf2uDf0XxpUOqD
 Jc1/4ODWRorUGinIAuksQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, FUJITA Tomonori wrote:

> If you don't clean up them, I think that it's better to leave out
> asm-generic/dma-generic-linear.h for
> now. asm-generic/dma-generic-linear.h is supposed to clean up the
> mess; unify (generalize, or fix) some architecture. It's not supported
> to add another temporary hack that should be removed.

Ok. I have no more ideas on how to do that in a cleaner way
than what I suggested, so I'll stop bothering you with it.

	Arnd <><
