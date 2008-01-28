Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbYA1VB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbYA1VB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761993AbYA1VBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:01:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761524AbYA1VBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:01:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [NET]: Remove PowerPC code from fec.c
Date: Mon, 28 Jan 2008 22:01:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jochen Friedrich <jochen@scram.de>, Frans Pop <elendil@planet.nl>,
       linux-m68k@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, geert@linux-m68k.org, gerg@uclinux.org,
       scottwood@freescale.com, jgarzik@pobox.com
References: <4799F349.9090102@scram.de> <E1JIQpQ-0006Xj-RR@faramir.fjphome.nl> <479A087F.5010305@scram.de>
In-Reply-To: <479A087F.5010305@scram.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282201.18658.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX199N36J+ejXzjgSYTe5aUJ/x6SNWATnNGr4Huz
 GEU9AiF7CkNhKmZfK4IccZmBzqv6fcu8KY+6/AelTmzXYWDaE8
 j3OSmx1Ihx6jVoVPuEXpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008, Jochen Friedrich wrote:
> Maybe the wording should be changed to:
> 
> This driver is now only used on ColdFire (m68knommu) processors. Conditional
> PowerPC code has been removed.
> 

How about adding a pointer to the driver that is now used on powerpc,
for the people that are looking in here?

	Arnd <><
