Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYEDWn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYEDWn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbYEDWnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:43:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbYEDWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:43:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 49/56] microblaze_v2: fcntl.h sockios.h ucontext.h
Date: Mon, 5 May 2008 00:43:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu> <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>
In-Reply-To: <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050043.43125.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+UArpW4DiTM2nYosgoOJmnl8nDMrlvAIxuEnS
 sSzh/vqtJMx6wk0UgtYg+TFn4K2WEThnPlfChacgGhh2Pox3FZ
 xZC4MArPyWweV96g9suoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
>  include/asm-microblaze/fcntl.h    |  104 +++++++++++++++++++++++++++++++++++++

Use the existing asm-generic version for this.

>  include/asm-microblaze/sockios.h  |   25 +++++++++
>  include/asm-microblaze/ucontext.h |   24 +++++++++

turn these into asm-generic versions.

	Arnd <><
