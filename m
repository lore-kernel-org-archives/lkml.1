Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZCKJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZCKJiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZCKJiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:38:03 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53174 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751947AbZCKJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:38:03 -0400
Date: Wed, 11 Mar 2009 10:37:58 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <1236729444.7086.24.camel@pasglop>
Message-ID: <alpine.LRH.2.00.0903111028480.1040@vixen.sonytel.be>
References: <1236729444.7086.24.camel@pasglop>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Benjamin Herrenschmidt wrote:
> Here are some late fixes for 2.6.29. I've included a radeonfb/aty128fb commit

Will you also take care of the new ps3vram driver, which has been ack'ed by
Jens for 2.6.29?
Or do you prefer it to go in by email through Geoff (as PS3 maintainer), or
from me directly?

Thanks!

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
