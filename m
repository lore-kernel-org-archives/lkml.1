Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0BARjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:39:33 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:47571 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0BARja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:39:30 -0500
Date: Mon, 01 Feb 2010 12:39:28 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [Bug #15125] hung task - jbd2/dm-1-8 (during raid rebuild)
In-reply-to: <4B662358.7020603@majjas.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Message-id: <4B6711D0.4060300@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
 <d3IDKWHT5gE.A.vVC.q7hZLB@chimera> <4B662358.7020603@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/2010 7:42 PM, Michael Breuer wrote:
> On 1/31/2010 7:22 PM, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.32.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=15125
>> Subject        : hung task - jbd2/dm-1-8 (during raid rebuild)
>> Submitter    : Michael Breuer<mbreuer@majjas.com>
>> Date        : 2010-01-10 21:47 (22 days old)
>> References    : http://marc.info/?l=linux-kernel&m=126316012025978&w=4
>>
> Yup. Hit it again on 2.6.33-rc5.
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
I was not able to recreate this in rc6.
