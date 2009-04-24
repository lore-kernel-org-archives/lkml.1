Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbZDXME3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbZDXME3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZDXMET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:04:19 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45940 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZDXMET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:04:19 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: remove PT_DTRACE from m68k, m68knommu
References: <20090423193211.GA14892@redhat.com> <m2tz4e5psn.fsf@igel.home>
	<10f740e80904240357r63fc9d4i5f8a4e6a5530b671@mail.gmail.com>
X-Yow: This ASEXUAL PIG really BOILS my BLOOD...  He's so..so.....URGENT!!
Date: Fri, 24 Apr 2009 14:04:09 +0200
In-Reply-To: <10f740e80904240357r63fc9d4i5f8a4e6a5530b671@mail.gmail.com>
	(Geert Uytterhoeven's message of "Fri, 24 Apr 2009 12:57:09 +0200")
Message-ID: <m2d4b25kcm.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> But more interestingly, Roman's last cleanup said there's no need to
> set TIF_DELAYED_TRACE?

Ok, I remember now.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
