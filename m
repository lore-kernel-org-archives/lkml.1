Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbYHKHTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbYHKHTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 03:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYHKHTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 03:19:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYHKHTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 03:19:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] please pull cell merge branch
Date: Mon, 11 Aug 2008 09:18:56 +0200
User-Agent: KMail/1.9.9
Cc: Paul Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, oprofile-list@lists.sourceforge.net,
       Robert Richter <robert.richter@amd.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808091513.05251.arnd@arndb.de> <18591.30474.127939.243247@cargo.ozlabs.ibm.com>
In-Reply-To: <18591.30474.127939.243247@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808110918.57293.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19+AQy/mZH583WkalNTghaIncMKX+cpzW1fszQ
 1zIFJbVarqawrkjRaABVZ/5w+h+581Xjz6RefZf9pwdtFZGrr7
 E+HZI8SxwmFiMSJLUQoAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Paul Mackerras wrote:
> Arnd Bergmann writes:
> > I've fixed one last bug in Carl's update for cell-oprofile (int flags
> > instead of unsigned long flags) and made sure the comments fit the
> > usual style. This fixes a long-standing bug that prevented us from
> > using oprofile on SPUs in many real-world scenarios. 
>
> Since you're touching generic oprofile code here, do you have an ack 
> from the oprofile maintainer?  Or is the oprofile maintainer listed in
> MAINTAINERS (Robert Richter) no longer active or something?
> 

Sorry about that. I had assumed that at the very least Carl had had
the oprofile list on Cc and that people there just didn't care.

Robert has just recently taken over maintainership for oprofile,
so I assume that he is indeed active and interested in the patches.
I'll send them out again for his review on oprofile-list.

	Arnd <><
