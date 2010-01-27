Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131Ab0A0MxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0A0MxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731Ab0A0MxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:53:07 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:49016 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab0A0MxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:53:06 -0500
Message-ID: <4B60373A.6010902@xenontk.org>
Date: Wed, 27 Jan 2010 18:23:14 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>	 <q60Z28d_9yH.A.7k.sZMXLB@chimera> <84144f021001270444o1a2eba51t7917fb447cdc247d@mail.gmail.com>
In-Reply-To: <84144f021001270444o1a2eba51t7917fb447cdc247d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 06:14 PM, Pekka Enberg wrote:
> On Mon, Jan 25, 2010 at 12:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.31 and 2.6.32.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.31 and 2.6.32. �Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry � � � : http://bugzilla.kernel.org/show_bug.cgi?id=14897
>> Subject � � � � : i915: Commit 0e442c60 causes flickering
>> Submitter � � � : David John <davidjon@xenontk.org>
>> Date � � � � � �: 2009-12-09 17:26 (47 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
>> References � � �: http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> 
> David, bunch of i915 flickering fixes have gone into 2.6.33-rc5. Is
> this still a problem?
> 

Yes, this is a separate issue the cause of which I've informed Jesse
about today. I've sent a patch but it needs reviewing. So the entry
should still be open.

Regards,
David.
