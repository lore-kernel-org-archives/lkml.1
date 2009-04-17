Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZDQDVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZDQDVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZDQDVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:21:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:24955 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbZDQDV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:21:29 -0400
Message-ID: <49E7F5AF.8040702@gawab.com>
Date: Thu, 16 Apr 2009 20:21:19 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13106] 2.6.30-rc1: intel 3945 no wireless
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.sp.Zw85JB@chimera> <49E7D320.3080900@lwfinger.net>
In-Reply-To: <49E7D320.3080900@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13106
>> Subject		: 2.6.30-rc1: intel 3945 no wireless
>> Submitter	: 2.6.30-rc1: intel 3945 no wireless
>> Date		: 2009-04-08 5:36 (9 days old)
>> References	: http://marc.info/?l=linux-kernel&m=123916905605534&w=4
>>     
>
> That regression was fixed by Herbert Xu's commit 97c18e2c. It should no longer
> be listed.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
I'm the original submitter. I confirm that it's been fixed -- close bug.

Justin Madru
