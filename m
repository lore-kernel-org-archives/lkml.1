Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYENQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYENQim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYENQif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:38:35 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63130 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751731AbYENQie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:38:34 -0400
Date: Wed, 14 May 2008 17:37:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Kim B. Heino" <Kim.Heino@bluegiga.com>
cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] add support for ST M41T94 SPI RTC
In-Reply-To: <482AF5E7.9070801@bluegiga.com>
Message-ID: <Pine.LNX.4.55.0805141736230.15223@cliff.in.clinika.pl>
References: <482AD8D9.4090805@bluegiga.com> <20080514150820.7eb523c6@i1501.lan.towertech.it>
 <482AF5E7.9070801@bluegiga.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Kim B. Heino wrote:

> Ok, I'll add support for century bit. Again there are some other 
> rtc-drivers (like rtc-m41t80.c and rtc-ds1307.c) not using it.

 Oh, thanks for mentioning rtc-m41t80.c -- since I am currently fiddling 
with it, it sounds like a good idea for an improvement.  Thanks!

  Maciej
