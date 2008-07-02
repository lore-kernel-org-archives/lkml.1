Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbYGBWXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbYGBWXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYGBWXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:23:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYGBWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:23:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 21/23] make section names compatible with -ffunction-sections -fdata-sections: v850
Date: Thu, 3 Jul 2008 00:17:52 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, vda.linux@googlemail.com,
       linux-arch@vger.kernel.org, rmk@arm.linux.org.uk, dhowells@redhat.com,
       ralf@linux-mips.org, kernel@wantstofly.org, jwboyer@linux.vnet.ibm.com,
       paulus@samba.org, dwmw2@infradead.org, torvalds@linux-foundation.org,
       paul.gortmaker@windriver.com, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       schwidefsky@de.ibm.com, davem@davemloft.net
References: <200807020242.21960.vda.linux@googlemail.com> <20080702145859.a9af30ea.akpm@linux-foundation.org> <486BFC21.1040001@firstfloor.org>
In-Reply-To: <486BFC21.1040001@firstfloor.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030017.53747.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pO3ulzoL1vYV5myjhiTQYZLPT//yqhIruMsy
 oskMCewSSGPKHDp7An0sKborDfh18nMsR0orCz1hejs5jy8pDF
 Ku6IO+n01kmiehd6+myEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 July 2008, Andi Kleen wrote:
> Same seems to be true for cris btw.

Cris has seen significant updates in 2.6.25 by its maintainer.
It's not a very active port, but skipping updates for one kernel
version is on a completely different scale from doing nothing
at all for over three years as in the v850 case.

I don't currently see any architecture (other than v850) in a
state that justifies removing it entirely.

	Arnd <><
