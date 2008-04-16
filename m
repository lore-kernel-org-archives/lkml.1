Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbYDPPdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbYDPPdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbYDPPdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:33:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbYDPPdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:33:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: Microblaze Linux release
Date: Wed, 16 Apr 2008 17:33:03 +0200
User-Agent: KMail/1.9.9
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
References: <48020A21.4000404@seznam.cz> <200804160944.42734.arnd@arndb.de> <48061B36.20800@seznam.cz>
In-Reply-To: <48061B36.20800@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161733.04714.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Sa5uHM2UNJUjD5IURoSqJk6QqCgMP1p0gU7P
 CryvX4K5OFJDvwOzUsMd/LKHjj8+PhMbwx/56SW8fjmLzk6ZPU
 1E7p9TIgUOn5gURW4Mr0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Michal Simek wrote:
> > One more reason for the microblaze kernel to base on top of linux-next
> > instead of mainline.
> 
> For me is not difficult to use lmb from microblaze/mm or from lib if the files
> are the same.
> 

What I meant is that there are a number of reasons to use linux-next
as a base for your kernel (this being one of them) and few against.

	Arnd <><
