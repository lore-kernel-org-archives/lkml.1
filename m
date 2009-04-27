Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbZD0PQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbZD0PQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbZD0PP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:15:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737AbZD0PPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:15:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC 00/17] asm-generic ABI files for microblaze
Date: Mon, 27 Apr 2009 17:15:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       monstr@monstr.eu, linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
       liqin.chen@sunplusct.com,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <200904271640.44445.arnd@arndb.de> <20090427151241.GA10558@uranus.ravnborg.org>
In-Reply-To: <20090427151241.GA10558@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271715.33676.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+TAMksHJ/w2Uq/4Tq1AhCXeRygg4lTLrgehuU
 P0fszGuaHC0T+sE+0Xx8L6Eds8L4ZXW4LX64hsklWi5p4YLvqS
 24O9sKCljuG+ELAaRdjWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Sam Ravnborg wrote:
> The submission is seriously broken.
> - subject is missing
> - reply-to-all is broken
> 
> Can you resend with this fixed, then it makes review easier.
> 

Sure, I have already done this and identified the problem: I had
an extra '>' character in the description file I entered in quilt
mail. For some reason, kmail still showed the patches correctly,
by they got corrupted on the way out anyway. I'll look into
using git-send-email in the future.

	Arnd <><
