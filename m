Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXFAKaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXFAKaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 06:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXFAKag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 06:30:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbXFAKaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 06:30:35 -0400
Message-ID: <465FF539.6090506@redhat.com>
Date: Fri, 01 Jun 2007 06:30:17 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: BUG: sleeping function called from invalid context at kernel/fork.c:385
References: <617E1C2C70743745A92448908E030B2A01961AFE@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01961AFE@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Luck, Tony wrote:
>> I used the sn2_defconfig in the tree :)
>>     
>
> So there is something odd happening.  Russ complained that he
> was still seeing several errors from the sn2_defconfig build
> too when I posted the "last fix" to Len.  But I don't see them
> when I build.
>
>   

Adding Vivek.

I've solved quite a few of the section mismatch errors as well.  I'll 
take a look to see what the problem is.

Tony, what system are you using to compile on, OS, etc?

P.

> -Tony
>   
