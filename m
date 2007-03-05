Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXCESiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXCESiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCESiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:38:06 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:41492 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbXCESiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:38:05 -0500
Date: Mon, 05 Mar 2007 13:37:12 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <4d8e3fd30703050722g7844a316m78da0522f0cc81b3@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>,
       "Andrew Morton" <akpm@osdl.org>,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
Message-id: <200703051337.13072.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
 <200703050453.08154.gene.heskett@gmail.com>
 <4d8e3fd30703050722g7844a316m78da0522f0cc81b3@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Paolo Ciarrocchi wrote:
>On 3/5/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Monday 05 March 2007, Nicolas Mailhot wrote:
>> >This looks like -mm stuff if you want it in 2.6.22
>>
>> This needs to get to 2.6.21, it really is that big an improvement.
>
>On 3/5/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Monday 05 March 2007, Nicolas Mailhot wrote:
>> >This looks like -mm stuff if you want it in 2.6.22
>>
>> This needs to get to 2.6.21, it really is that big an improvement.
>
>I didn't try the new cpu scheduler but 2.6.21 is in bug fix only mode
>so I don't see how this stuff can go in.
>
>Maybe Andrew can comment about having it in -mm?
>
>Ciao,

In that case, I hope that Con can update the patch to apply to 2.6.21 when 
final is out.  In the meantime I've not had usable luck with -rc1 
nor -rc2  rc1 didn't want to boot after uncompressing, and rc2 is about 
as fast as a 3 day old carcass.  And beating on it doesn't help, the 
stalls are 30+ seconds at a time.  And nothing in the logs.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
