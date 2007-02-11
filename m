Return-Path: <linux-kernel-owner+w=401wt.eu-S1750744AbXBKRTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750744AbXBKRTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbXBKRTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:19:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57720 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXBKRTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:19:43 -0500
Message-ID: <45CF4F52.7030509@oracle.com>
Date: Sun, 11 Feb 2007 09:16:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: lkml@pengaru.com, clemens@dwf.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Still cant boot 2.6.20
References: <200702110620.l1B6KoNT025415@deneb.dwf.com> <20070211070247.GP5762@shells.gnugeneration.com> <20070210231234.33dedf24.randy.dunlap@oracle.com> <20070211073731.GQ5762@shells.gnugeneration.com> <20070211083715.GB943@1wt.eu>
In-Reply-To: <20070211083715.GB943@1wt.eu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Sun, Feb 11, 2007 at 01:37:31AM -0600, lkml@pengaru.com wrote:
>> On Sat, Feb 10, 2007 at 11:12:34PM -0800, Randy Dunlap wrote:
>>> On Sun, 11 Feb 2007 01:02:47 -0600 lkml@pengaru.com wrote:
>>>
>>>> I don't see CONFIG_BLK_DEV_INITRD=y
>>>>
>>>> Regards,
>>>> Vito Caputo
>>>>
>>>> BTW, this isnt the appropriate place for asking this type of question...
>>> Please explain why not.
>>>
>>> And please delete large parts of email that are not needed in replies
>>> (like the .config).
>>> Thanks.
>>>
>> I was under the impression that lkml is for kernel development, not basic help
>> with configuring your kernel.

We also value feedback and problem reports from testers.
That's all this was until your diagnosis.

>> >From the FAQ at http://www.tux.org/lkml/#s3-8
>>
>>  "Remember that this is a list for the discussion of kernel development."
> 
> You are right, but development also needs feedback. Until the user notices
> it is just a configuration error, it is perfectly possible that his problem
> is caused by a recently introduced bug. You reply put the finger on the
> error (missing CONFIG_BLK_DEV_INITRD). That's perfect. He would be off-topic
> if he went back asking "how do I add this option ?".

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
