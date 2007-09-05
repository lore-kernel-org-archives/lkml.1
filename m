Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbXIEOAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbXIEOAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbXIEOAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:00:07 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:33955 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbXIEOAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:00:05 -0400
Message-ID: <46DEB664.2090704@opengridcomputing.com>
Date: Wed, 05 Sep 2007 09:00:04 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Divy Le Ray <divy@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/11] cxgb3 - engine microcode update
References: <20070822034947.9404.87301.stgit@speedy5> <46D819CE.5050207@garzik.org>
In-Reply-To: <46D819CE.5050207@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeff Garzik wrote:
> Divy Le Ray wrote:
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Load microcode engine when the interface
>> is configured up.
>> Bump up version to 1.1.0.
>> Allow the driver to be and running with
>> older microcode images.
>> Allow ethtool to log the microcode version.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> 
> ACK patches 9-14, but dropped, since they do not apply to #upstream 
> (probably due to fixes sent into 2.6.23-rc)
> 

Hey Jeff,

I think 9-14 still need to be incorporated.  I don't see them in your 
upstream branch, and they aren't in linus' tree either.

Steve.

