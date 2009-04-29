Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZD2JLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZD2JLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZD2JIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:08:41 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47358 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753706AbZD2JIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:08:39 -0400
Date: Wed, 29 Apr 2009 11:08:37 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revert "linux.conf.au 2009: Tuz"
In-Reply-To: <200904280300.n3S302bx007674@hera.kernel.org>
Message-ID: <alpine.LRH.2.00.0904291103150.715@vixen.sonytel.be>
References: <200904280300.n3S302bx007674@hera.kernel.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

On Tue, 28 Apr 2009, Linux Kernel Mailing List wrote:
> Commit:     3d4f16348b77efbf81b7fa186a18a0eb815b6b84

>     Revert "linux.conf.au 2009: Tuz"
>     
>     This reverts commit 8032b526d1a3bd91ad633dd3a3b5fdbc47ad54f1.

BTW, you forgot to update the main Makefile ;-)

| $ grep ^NAME Makefile 
| NAME = Temporary Tasmanian Devil
| $ 

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
