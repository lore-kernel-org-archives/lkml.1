Return-Path: <linux-kernel-owner+w=401wt.eu-S936515AbXGZWSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936515AbXGZWSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762513AbXGZWRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:17:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:22356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764718AbXGZWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:17:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="110387699"
Message-ID: <46A91D8F.2000202@intel.com>
Date: Thu, 26 Jul 2007 15:17:51 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Nelson, Shannon" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] I/OAT: Add support for DCA - Direct Cache Access
References: <BAE9DCEF64577A439B3A37F36F9B691C02C1F61B@orsmsx418.amr.corp.in tel.com> <alpine.LFD.0.999.0707261148140.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707261148140.3442@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2007 22:17:52.0188 (UTC) FILETIME=[CEBC57C0:01C7CFD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 26 Jul 2007, Nelson, Shannon wrote:
>> In order to include support for DCA (Direct Cache Access) from IOAT,
>> please pull from my git tree at
>> 	git://lost.foo-projects.org/~sln/linux-2.6 dma-upstream
> 
> No. It's after the merge window, and I'm not interested for 2.6.23. 
> 
> Why cannot people learn? If it didn't get into -rc1, it's not in. It 
> really is that simple. I shouldn't have to shout at people. 

I/OAT / dmaengine patch merge path has been a complete mystery and 
unestablished. Dave Miller acked these patches during the merge window, so if 
Shannon can only send these to you during that period, and you are 100% likely 
to miss the Acks, this will never get merged.

Perhaps David should start merging I/OAT stuff instead? Someone else? Chris had 
the same issues when he was maintaining this.

Auke
