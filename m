Return-Path: <linux-kernel-owner+w=401wt.eu-S1763873AbXH3Wm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763873AbXH3Wm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763165AbXH3Wmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:42:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763126AbXH3Wmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:42:49 -0400
Message-ID: <46D74797.4070105@zytor.com>
Date: Thu, 30 Aug 2007 15:41:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, werner@almesberger.net
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com> <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain> <200708301836.48707.rob@landley.net>
In-Reply-To: <200708301836.48707.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Thursday 30 August 2007 1:28:17 pm Robert P. J. Day wrote:
>> On Thu, 30 Aug 2007, Randy Dunlap wrote:
>>
>> ...
>>
>>> The old "ramdisk=<ram_size>" has been changed to
>>> "ramdisk_size=<ram_size>" to make it clearer.  The original
>>> "ramdisk=<ram_size>" has been kept around for compatibility reasons,
>>> but it may be removed in the future.
>> ...
>>
>> i just the other day submitted a patch to remove that backward
>> compatibility, and the m68k portion of it has already been acked by
>> geert uytterhoeven.
> 
> Could you mention it in feature-removal-schedule.txt?  (People check that for 
> warning of upcoming changes that impact existing code.  They may not notice 
> something elsewhere after they've got it working...)
> 

The same objection applies to this as to the previous one.  In that 
respect, an Ack from a maintainer of an almost unused architecture is 
meaningless (sorry, Geert.)

	-hpa

