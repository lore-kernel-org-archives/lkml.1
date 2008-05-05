Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYEEJvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYEEJvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYEEJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:50:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYEEJu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:50:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 43/56] microblaze_v2: termbits.h termios.h
Date: Mon, 5 May 2008 11:50:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu> <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
In-Reply-To: <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805051150.41642.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX196QGXFJGcykd9/XeXo+UN0+ovC6LNH3fZ0QdX
 h2u0OSBJQUdSa209f4vCahyLCGXT175Qr8FJ8BsHshtT93BpfN
 7AhXLRaTvlcOHXOZEshCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
>  include/asm-microblaze/termbits.h |  203 +++++++++++++++++++++++++++++++++++++
>  include/asm-microblaze/termios.h  |   86 ++++++++++++++++

Both of these are candidates for asm-generic, but I haven't looked
at them in detail yet.

	Arnd <><
