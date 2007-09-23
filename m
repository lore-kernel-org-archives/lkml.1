Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbXIWBEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbXIWBEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXIWBE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:04:28 -0400
Received: from barikada.upol.cz ([158.194.242.200]:40485 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXIWBE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:04:28 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mihai.dontu@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
In-Reply-To: <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
References: <20070922220347.586903979@linutronix.de> <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
Date: Sun, 23 Sep 2007 03:20:07 +0200
Message-Id: <E1IZG8l-0002jB-2k@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 22 Sep 2007 15:59:25 -0700 (PDT)

As i never had any suspend working ever, let me point this LKML post

http://mid.gmane.org/200709221746.14429.mihai.dontu@gmail.com

from Mihal, who just managed to do some other magic in sligtly
different context (maybe yet another anti "ACPI screwed up").

Mihai, you can find whole thread by above URL, requesting message-ids
from in-reply-to or references headers of this message.
_____
