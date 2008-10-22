Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYJVRO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYJVRO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYJVROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:14:42 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62973 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752385AbYJVROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:14:41 -0400
Date: Wed, 22 Oct 2008 19:14:39 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only filesystem
In-Reply-To: <E1KqrTW-0001x8-3h@dylan>
Message-ID: <Pine.LNX.4.64.0810221913330.20919@vixen.sonytel.be>
References: <E1KqrTW-0001x8-3h@dylan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1009736283-1224695679=:20919"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1009736283-1224695679=:20919
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Phillip,

On Fri, 17 Oct 2008, Phillip Lougher wrote:
> This is a second attempt at mainlining Squashfs.  The first attempt was way

This is great news!

I ran a quick test of squashfs 4.0 (the CVS version) on UML/ia32 and ppc64, and it
seems to work fine!  Great job! Let's hope we'll see it in mainline soon...

BTW, one minor gripe is that the current mksquashfs doesn't want to run on big
endian yet, as there's no byteswapping support.

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
---584349381-1009736283-1224695679=:20919--
