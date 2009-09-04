Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZIDKrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZIDKrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZIDKrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:47:13 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42816 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZIDKrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:47:12 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432R98dN14ffOa594izz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KPG0LR-01-6BE-02
X-M-MSG: 
Date: Fri, 4 Sep 2009 12:45:40 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 4
Message-ID: <20090904104540.GC28389@aftab>
References: <20090904182309.dbb05c96.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090904182309.dbb05c96.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Sep 2009 10:45:25.0413 (UTC) FILETIME=[CF6AD550:01CA2D4C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Sep 04, 2009 at 06:23:09PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090903:

..

> Merging edac-amd/for-next
> CONFLICT (content): Merge conflict in arch/x86/kernel/smpboot.c
> CONFLICT (content): Merge conflict in include/linux/topology.h

current topology patches in -tip have significantly diverged from the
versions I carry in the edac tree so please remove the last from the
testing lineup temporarily. Will fix the issue after I'm back from my
vacation the week after next.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

