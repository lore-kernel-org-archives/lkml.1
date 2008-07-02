Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYGBVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYGBVqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYGBVq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:46:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:55456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYGBVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:46:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 21/23] make section names compatible with -ffunction-sections -fdata-sections: v850
Date: Wed, 2 Jul 2008 23:45:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
References: <200807020242.21960.vda.linux@googlemail.com>
In-Reply-To: <200807020242.21960.vda.linux@googlemail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807022345.40184.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX190HzvgdBrHK2JplN0cxhG4HRuXfchyrBgrL4r
 EhFWGmcPNxtvvhPvtqZJsp7Hcg7CthbKVpNTXZDgzTMBPyfX7K
 bB/ceegDxWf4axK6lhjYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008, Denys Vlasenko wrote:
> This patch fixes v850 architecture.

For all I know, v850 has been broken and unmaintained for a few years now,
didn't someone have a patch to remove it entirely?

	Arnd <><
