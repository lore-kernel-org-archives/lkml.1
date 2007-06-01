Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbXFADcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbXFADcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 23:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXFADbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 23:31:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbXFADby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 23:31:54 -0400
Message-ID: <465F9315.2050207@redhat.com>
Date: Thu, 31 May 2007 23:31:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/fork.c:385
References: <617E1C2C70743745A92448908E030B2A01961A60@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01961A60@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Luck, Tony wrote:
>> Tony, the ia64 section mismatch "whack-a-mole" is far from over :(
>>     
>
> Can you post the .config file that you are using when you see all those
> warnings ... I'll start bopping them on their cute little heads.
>
>   

Hi Tony,

I used the sn2_defconfig in the tree :)

P.

> -Tony
>   
