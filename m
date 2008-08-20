Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYHTNUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYHTNUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbYHTNT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:19:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63072 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYHTNT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:19:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Date: Wed, 20 Aug 2008 15:19:18 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
       cel <cel@linux.vnet.ibm.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808110925.08485.arnd@arndb.de> <20080820123944.GQ13011@erda.amd.com>
In-Reply-To: <20080820123944.GQ13011@erda.amd.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201519.19453.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FiC76K7r1DzBiugOYon+K/moxrrPTa8Nbcvm
 AHD+d/WlVaZA5BgW4oRvfL+nM3Xea0MO46BgiOSR3piui0yTqp
 Dsm7xEUv8SPRWVurLwOdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008, Robert Richter wrote:

> > Signed-off-by: Carl Love <carll@us.ibm.com>
> > Signed-off-by: Maynard Johnson <maynardj@us.ibm.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Robert Richter <robert.richter@amd.com>
> 

Thanks Robert.

Paul, any chance we can still get this into 2.6.27?

I've added the Ack and uploaded it again for you to
pull from

 master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge

	Arnd <><
