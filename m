Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbYDPATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbYDPATi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYDPAT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:19:27 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54956 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYDPAT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:19:27 -0400
Date: Wed, 16 Apr 2008 03:19:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot
	-dual-core Sony Vaio
Message-ID: <20080416001925.GM1677@cs181133002.pp.htv.fi>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804152233.39079.rjw@sisk.pl> <20080415204500.GD1677@cs181133002.pp.htv.fi> <200804152303.45320.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com> <1208294294.7851.109.camel@localhost> <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com> <20080415212949.GG1677@cs181133002.pp.htv.fi> <20080415225411.GA10041@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080415225411.GA10041@localhost.ift.unesp.br>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:54:11PM -0300, Carlos R. Mafra wrote:
> On Wed 16.Apr'08 at  0:29:49 +0300, Adrian Bunk wrote:
>...
> > We must learn to more aggressively point people at reporting their 
> > issues in own bugs, instead of hijacking an already existing similar
> > looking bug (that might be for a different issue).
> 
> I understand now, but you made me feel bad about it.

Sorry for my wording, it was not meant personally.

It's a general problem in bug trackers that one person reports one 
issue, and other people say "I have the same bug" and start discussing 
their problem, which might or might not turn out to be the same.

And the result was e.g. here that Venki marked #10377 as a duplicate of 
#10117 saying "Both are Core 2 Duo based with 64 bit kernel." although 
this is not true for the bug #10117 was originally created for.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

