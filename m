Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZDQI3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZDQI3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbZDQI3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:29:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:37644 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbZDQI26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j4Q7mv2bVM0N9QDkqPm3ouliYekFvhtbNRhkrO/bNG8Y9YpMZ6QM0sKKGZTC6VN/qo
         HtPzYzTi5E6E/aPdp2LvsQlHLeRyf/JDxg6Qr2a6ENTGWtWO3DxNvajX86ZaKPs7KKh+
         xWg0T2sjAMpuK3BwEeIZh0+fx1Vkm9bpYn0GE=
Message-ID: <49E83DC4.8040207@tuffmail.co.uk>
Date: Fri, 17 Apr 2009 09:28:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk>
In-Reply-To: <20090417063007.GB4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Apr 16 2009, Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13058
>> Subject		: First hibernation attempt fails
>> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Date		: 2009-04-10 10:58 (7 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1faa16d22877f4839bd433547d770c676d1d964c
>> References	: http://marc.info/?l=linux-kernel&m=123928022321917&w=2
>>     
>
> Alan, is this still a problem?
>   

Yup.  Still present in v2.6.30-rc2-195-g9f76208.
