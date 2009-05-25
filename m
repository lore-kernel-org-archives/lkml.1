Return-Path: <linux-kernel-owner+w=401wt.eu-S1751117AbZEYEkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbZEYEkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 00:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZEYEkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 00:40:03 -0400
Received: from windsormachine.com ([216.8.138.2]:50630 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZEYEkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 00:40:02 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 00:40:01 EDT
Date: Mon, 25 May 2009 00:33:43 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: Alex Samad <alex@samad.com.au>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
In-Reply-To: <20090525002210.GE1339@samad.com.au>
Message-ID: <alpine.DEB.1.10.0905250032330.19424@router.windsormachine.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.RuC.RQcGKB@chimera> <20090525002210.GE1339@samad.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confirmed this is still a problem with 2.6.29.4

Mike

On Mon, 25 May 2009, Alex Samad wrote:

> Hi
>
> As far as I know it is still a problem
>
> Thanks
> Alex
>
> On Sun, May 24, 2009 at 09:31:20PM +0200, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.28 and 2.6.29.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13375
>> Subject		: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
>> Submitter	: Alex Samad <alex@samad.com.au>
>> Date		: 2009-05-20 0:37 (5 days old)
>> References	: http://marc.info/?l=linux-kernel&m=124278675503699&w=4
>>
>>
>>
>
>

