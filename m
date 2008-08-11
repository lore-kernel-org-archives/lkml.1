Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYHKOxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYHKOxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYHKOxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:53:45 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48031 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbYHKOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:53:44 -0400
Date: Mon, 11 Aug 2008 16:53:39 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Rusty Russell <rusty@rustcorp.com.au>,
       linuxppc-dev@ozlabs.org, Al Viro <viro@zeniv.linux.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC 2/3] powerpc: export all symbols from the definition file
In-Reply-To: <200808111617.53305.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0808111653170.3030@vixen.sonytel.be>
References: <200808111606.44103.arnd@arndb.de> <200808111617.53305.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-230652837-1218466419=:3030"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-230652837-1218466419=:3030
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 11 Aug 2008, Arnd Bergmann wrote:
> It's now possible to export symbols from .S files, so move all

Nice!

> exports out of the ppc_ksyms.c file to the definition of the
> symbols.

>  drivers/macintosh/adb.c              |    5 +++++
>  drivers/macintosh/via-cuda.c         |    3 +++

I think these 2 belong to patch 3?

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
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-230652837-1218466419=:3030--
