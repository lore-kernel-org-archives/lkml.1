Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbZJFAW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbZJFAW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZJFAW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:22:28 -0400
Received: from l2mail1.panix.com ([166.84.1.75]:51279 "EHLO l2mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbZJFAW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:22:27 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 20:22:27 EDT
Message-ID: <4ACA87DA.7000607@panix.com>
Date: Mon, 05 Oct 2009 19:57:14 -0400
From: berk walker <berk@panix.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Vladimir Dronnikov <dronnikov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com> <200910051630.51039.rob@landley.net>
In-Reply-To: <200910051630.51039.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Monday 05 October 2009 11:01:39 Vladimir Dronnikov wrote:
>> From: Vladimir Dronnikov <dronnikov@gmail.com>
>>
>> drivers/md/unroll.pl replaced by awk script to drop build-time dependency
>> on perl
>>
>> Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>
> 
> Acked-by: Rob Landley <rob@landley.net>
> 
> We already discussed this on another mailing list, thread starts at:
> 
> http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2009-October/000328.html
> 
> I've added this as patch #4 in the perl removal series I've submitted
> during the last few merge windows.
> 
> Thanks,
> 
> Rob
Why is perl being removed? [I know that I have missed a lot]
berk-

