Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYILL0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYILL0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYILL0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:26:13 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42545 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752739AbYILL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:26:12 -0400
Date: Fri, 12 Sep 2008 13:26:07 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Chuck Ebbert <cebbert@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>
cc: Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] Unfixed regressions in 2.6-stable
In-Reply-To: <48C9A8C4.9080803@redhat.com>
Message-ID: <Pine.LNX.4.64.0809121324260.20811@vixen.sonytel.be>
References: <48C9A8C4.9080803@redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-876705403-1221218671=:20811"
Content-ID: <Pine.LNX.4.64.0809121325140.20811@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-876705403-1221218671=:20811
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0809121325141.20811@vixen.sonytel.be>

On Thu, 11 Sep 2008, Chuck Ebbert wrote:
> Description: Kernel hangs when booting on Sony PS3
> Version(s):  2.6.25.12 - 2.6.25.17
> Caused-by:
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.25.12/usb-fix-interrupt-disabling-for-hcds-with-shared-interrupt-handlers.patch;hb=HEAD
> Version(s):  2.6.26 - 2.6.26.5
> Caused-by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=de85422b94ddb23c021126815ea49414047c13dc
> Patch:
> http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob_plain;f=usb.current/usb-fix-hcd-interrupt-disabling.patch;hb=HEAD
> Patch is not in mainline.

Greg, any chance we can get this in 2.6.27?

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
---584349381-876705403-1221218671=:20811--
