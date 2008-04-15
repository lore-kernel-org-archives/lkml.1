Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbYDOVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbYDOVqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbYDOVqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:46:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37125 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157AbYDOVqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:46:03 -0400
Date: Wed, 16 Apr 2008 00:44:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Soeren Sonnenburg <kernel@nn7.de>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot -
	dual-core Sony Vaio
Message-ID: <20080415214451.GJ1677@cs181133002.pp.htv.fi>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com> <1208294294.7851.109.camel@localhost> <200804152324.18597.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEEE1800F@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEE1800F@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 02:33:02PM -0700, Pallipadi, Venkatesh wrote:
>...
> Last I heard from Soeren, this was not reproducable on 32 bit any more.

Soeren has confirmed this.

His bug (that was a 2.6.25 regression) seems to be fixed, and the bug is 
therefore closed.

> All recent updates on #10117 from Carlos is on Core-2 Duo 64 bit. If the
> problem is still reproducable on 32 bit then probably having 2 bugzillas
> to track is fine with me.

#10117 seems to have comments about reported by at least 3 people other 
than Soeren, and unless you are 100% sure these are for the same issue 
each of them deserves an own bug.

Although it might sound like bureaucratic overkill having separate bugs 
even for reports that might be for the same issue prevents situations 
like we just had in #10117.

> Thanks,
> Venki

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

