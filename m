Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZGORxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZGORxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZGORxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:53:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62574 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZGORxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Af5Kp1x/NWpeEHJM7/j2qnGK0P4YyeMftvTnWnyiMwrfWNdLzOYdQXpkeYiQseV+Ct
         H0ERGB6tHOsSFwo3PT0BZkHYzWVmP1UE8FK+gQgzrB/yaZjuWTnwAttYFN1DYG6TuDCK
         CCN3z2MOt66Bnlpoc1ylEu8rfWi0FXEt75zMI=
MIME-Version: 1.0
In-Reply-To: <4A5D82EA.1070002@turknet.net.tr>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <dWkuWjWDsSB.A.8EE.Q0oUKB@chimera> <4A5D82EA.1070002@turknet.net.tr>
Date: Wed, 15 Jul 2009 19:53:14 +0200
Message-ID: <8db1092f0907151053v5731f409ydd81465d20c929f8@mail.gmail.com>
Subject: Re: [Bug #13727] Cannot Recognize Empty DVD Media
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/15 Tarkan Erimer <tarkan.erimer@turknet.net.tr>:
> On 07/07/2009 03:01 AM, Rafael J. Wysocki wrote:
>>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13727
>> Subject         : Cannot Recognize Empty DVD Media
>> Submitter       : Tarkan Erimer<tarkan.erimer@turknet.net.tr>
>> Date            : 2009-07-02 16:23 (5 days old)
>> References      : http://lkml.org/lkml/2009/7/2/178
>>
>>
>>
>
> I confirm that, as of Linux-2.6.31-rc3, it's fixed.

I also confirm, that -rc3 works OK.

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
