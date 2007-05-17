Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbXEQBZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbXEQBZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXEQBZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:25:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60942 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106AbXEQBZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:25:32 -0400
Message-ID: <464BAF07.9020003@cv-sv.de>
Date: Thu, 17 May 2007 03:25:27 +0200
From: Christian <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/0/xFLhC711fJu4X7gUl1zQ5ILdpxwwErfENi
 RjP2RoVEkFawqQaCeJG7entvu4/zRm9rKOfHuzIgsj5ScOmTP8
 J1EILJpODYAC4flkJIxlw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Can you check? The Nehemian (C3-2) should be model 9 or greater.

Yes, it's a Nehemiah

lola:~ # cat /proc/cpuinfo
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 9
model name      : VIA Nehemiah
stepping        : 8
cpu MHz         : 998.732
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx fxsr sse rng rng_en ace ace_en
bogomips        : 1999.51
clflush size    : 32
