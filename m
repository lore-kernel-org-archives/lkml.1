Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbXEKBYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbXEKBYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbXEKBYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:24:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:27334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671AbXEKBYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,520,1170662400"; 
   d="scan'208";a="226831247"
Message-ID: <4643C5D3.3060303@intel.com>
Date: Thu, 10 May 2007 18:24:35 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Doug Chapman <doug.chapman@hp.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "e1000-devel@lists.sourceforge.net >> e1000-list" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: 2.6.21-gitX: known regressions
References: <46430A3D.4030004@googlemail.com> <20070510181044.d0f24e51.akpm@linux-foundation.org>
In-Reply-To: <20070510181044.d0f24e51.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 10 May 2007 14:04:13 +0200
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> Hi all,
>>
>> Here is a list of some known regressions in 2.6.21-gitX.
>>
>> Feel free to add new regressions/remove fixed etc.
>> http://kernelnewbies.org/known_regressions
>>
>>
>> Networking:
>>
>> Subject    : panic with e1000 driver on HP Integrity servers
>> References : http://bugzilla.kernel.org/show_bug.cgi?id=8455
>> Submitter  : Doug Chapman <doug.chapman@hp.com>
>> Caused-By  : Auke Kok <auke-jan.h.kok@intel.com>
>>              commit e0aac5a289b1dacbc94bd9ae8c449bcdf9ab508c
>> Status     : Unknown

We're trying to reproduce this in our labs here but that piece of code has been 
extensively tested on various platforms and architectures, so I'm a bit 
surprised about it. I've asked for more info on the bugzilla as well.

So, this is being worked on actively.

Cheers,

Auke
