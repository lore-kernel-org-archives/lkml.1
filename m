Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXIEOhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXIEOhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932084AbXIEOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:36:59 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:42265 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072AbXIEOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:36:58 -0400
Message-ID: <46DEBF09.5080808@opengridcomputing.com>
Date: Wed, 05 Sep 2007 09:36:57 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Divy Le Ray <divy@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/11] cxgb3 - engine microcode update
References: <20070822034947.9404.87301.stgit@speedy5> <46D819CE.5050207@garzik.org> <46DEB664.2090704@opengridcomputing.com> <20070905143029.GC19543@havoc.gtf.org>
In-Reply-To: <20070905143029.GC19543@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeff Garzik wrote:
> On Wed, Sep 05, 2007 at 09:00:04AM -0500, Steve Wise wrote:
>>
>> Jeff Garzik wrote:
>>> Divy Le Ray wrote:
>>>> From: Divy Le Ray <divy@chelsio.com>
>>>>
>>>> Load microcode engine when the interface
>>>> is configured up.
>>>> Bump up version to 1.1.0.
>>>> Allow the driver to be and running with
>>>> older microcode images.
>>>> Allow ethtool to log the microcode version.
>>>>
>>>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>>> ACK patches 9-14, but dropped, since they do not apply to #upstream 
>>> (probably due to fixes sent into 2.6.23-rc)
>>>
>> Hey Jeff,
>>
>> I think 9-14 still need to be incorporated.  I don't see them in your 
>> upstream branch, and they aren't in linus' tree either.
> 
> I am not the blocker here.  Re-read the email you quoted.
> 
> 	Jeff, still waiting for the patches
> 

Ok.  I didn't get that you were stating that the patches should be 
resent because they're busted :)


Steve.

