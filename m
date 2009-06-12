Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZFLHCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZFLHCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZFLHCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:02:44 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:56097 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbZFLHCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:02:43 -0400
Message-ID: <4A31FD94.5040404@snapgear.com>
Date: Fri, 12 Jun 2009 17:02:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] m68knommu arch fixes
References: <200906120114.n5C1EYNj009715@localhost.localdomain> <10f740e80906112322k11a518dj3d059b19c086e0c6@mail.gmail.com>
In-Reply-To: <10f740e80906112322k11a518dj3d059b19c086e0c6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Geert Uytterhoeven wrote:
> On Fri, Jun 12, 2009 at 03:14, Greg Ungerer<gerg@snapgear.com> wrote:
>> Please pull to get fixes for the m68knommu arch.
> 
>> Jaswinder Singh Rajput (1):
>>      headers_check fix: m68k, swab.h
> 
> Thanks!

No problem :-)


> Probably I won't have time to handle and submit any m68k patches
> during this merge window,
> so if anyone needs anything to be in 2.6.31, it would be nice if
> somebody else could take care of
> it.

I have a few more header file re-merges that I have had sitting
around for a while, any chance you can review them?  (Or maybe I
just send them to the m68k-linux mailing list?)

Currently they are on the branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git includes

The easy ones are done, so the re-joining now is not completely
trivial. This set (of 5) is reasonably strait forward though.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
