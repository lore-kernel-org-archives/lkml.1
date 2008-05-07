Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYEGJWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYEGJWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbYEGJWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:22:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbYEGJWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:22:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
Date: Wed, 7 May 2008 11:21:40 +0200
User-Agent: KMail/1.9.9
Cc: Michal Simek <monstr@seznam.cz>,
       John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <48214B36.9060307@seznam.cz> <Pine.LNX.4.64.0805070917111.6341@anakin>
In-Reply-To: <Pine.LNX.4.64.0805070917111.6341@anakin>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071121.43006.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ICDHsiqjEjg3hl6oAzfzVjOVr7oUZMZVtZRP
 Ix8b7vI47UFnprdwi1/Dbs7qPTMNrEMsZV2OL1SAUYvcwEChi7
 udQ7qwix0fVtxQObbTQhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2008, Geert Uytterhoeven wrote:
> On Wed, 7 May 2008, Michal Simek wrote:
> > Is it OK now? This will moved to asm-generic too.
> 
> Ack.

looks good to me as well.

	Arnd <><
