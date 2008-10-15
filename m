Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYJOInQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYJOInQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYJOIm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:42:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYJOImZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:42:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: [git pull] Please pull from powerpc.git next branch
Date: Wed, 15 Oct 2008 10:41:28 +0200
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
References: <1224033396.8157.386.camel@pasglop> <20081015083516.GL23557@erda.amd.com>
In-Reply-To: <20081015083516.GL23557@erda.amd.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810151041.29069.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/oRMbI56lfCuh6tb7TMGXCVkEIxdc8Stsjz2F
 ElVOf1Lw+oRV0NPdoC1F/9d6Ed4nkn/dm/0+QYXEH0YrA8+ufo
 TIKNAAG/68kTGKdMRSVRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2008, Robert Richter wrote:
> there are still these OProfile patches for powerpc pending:
> 
> Carl Love (1):
>       powerpc/cell/oprofile: fix mutex locking for spu-oprofile
> 
> Roel Kluin (1):
>       powerpc/cell/oprofile: vma_map: fix test on overlay_tbl_offset
> 
> Can you or Paul send them upstream? You can pull from here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git powerpc-for-paul
> 

The patch from Roel is already in there, with a slightly different
subject line. The one from Carl is still missing.

	Arnd <><
