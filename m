Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbXDHR5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbXDHR5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 13:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXDHR5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 13:57:48 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:34361 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXDHR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 13:57:47 -0400
Date: Sun, 08 Apr 2007 13:57:43 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <1176033735.6404.2.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704081357.43370.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <1176032450.6304.3.camel@Homer.simpson.net>
 <1176033735.6404.2.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 April 2007, Mike Galbraith wrote:
>On Sun, 2007-04-08 at 13:40 +0200, Mike Galbraith wrote:
>> On Sun, 2007-04-08 at 07:33 -0400, Gene Heskett wrote:
>> > That seems to be the killer loading here, building a kernel (make
>> > -j3) doesn't seem to lag it all that bad.  One session of gzip -best
>> > makes it fall plumb over though, which was a disappointment.
>>
>> Can you make a testcase that doesn't require amanda?
>
>Or at least send me a couple of 5 or 10 second top snapshots (which also
>show CPU usage of sleeping tasks) while the system is misbehaving?
>
>	-Mike

With what monitor utility?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Microsoft technology" -- isn't that an oxymoron? 

   -- Gareth Barnard
