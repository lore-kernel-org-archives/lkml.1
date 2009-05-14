Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZENJOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZENJOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZENJNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:13:51 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35085 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbZENJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:13:50 -0400
Date: Thu, 14 May 2009 11:13:49 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
cc: Marc Dionne <marc.c.dionne@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.30 - /dev/pts - mount options - bisected
In-Reply-To: <20090513171519.GA937@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0905141113220.2225@vixen.sonytel.be>
References: <6041d2000905081454x4c9d8818oaccbcd14d1f4a506@mail.gmail.com> <alpine.LRH.2.00.0905131440010.28386@vixen.sonytel.be> <20090513171519.GA937@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Sukadev Bhattiprolu wrote:
> Geert Uytterhoeven [Geert.Uytterhoeven@sonycom.com] wrote:
> 
> | And indeed, disabling CONFIG_DEVPTS_MULTIPLE_INSTANCES in the Fedora-based
> | config makes the problem go away, and brings back my terminal-emulators.
> 
> Yes, a patch is available for this at
> 
> 	http://lkml.org/lkml/2009/5/11/586
> 
> The patch has been merged into -mm.

Thanks, I missed that one, as there were no replies to Marc's email.

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
