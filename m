Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbYFIQSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbYFIQSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYFIQSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:18:22 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:40401 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYFIQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gzooDJyuriPdKZmrlj4v9Mr1+MQm99wMu8LCZ4y2Fr5hZ6B5lNtQbqF60YIz9WTDw8
         88sGucUKvlNcDgKoNlbHJ4OF7uO0sniHoiBydrLY6BJsdCe2cPApRfqhjNrSF2IHvyD7
         GsuTQyNaQVJNMiDEzaZj/XORaUeqrnODdMnsk=
Message-ID: <dd18b0c30806090918j1426bd6etf78a20a87a0528f3@mail.gmail.com>
Date: Mon, 9 Jun 2008 16:18:19 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806091107.51994.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.SAD.x2vSIB@albercik>
	 <200806091107.51994.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 9:07 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Samstag 07 Juni 2008 22:42:57 schrieb Rafael J. Wysocki:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10825
>> Subject               : appletouch after wakeup
>> Submitter     : Justin Mattock <justinmattock@gmail.com>
>> Date          : 2008-05-27 3:29 (12 days old)
>> References    : http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
>>                 http://lkml.org/lkml/2008/5/31/193
>>                 http://lkml.org/lkml/2008/5/31/193
>> Handled-By    : Oliver Neukum <oliver@neukum.org>
>
> A patch is available but not yet in mainline.
>
>        Regards
>                Oliver
>

Cool; just an update, I've suspended the system numerous times it
seems appletouch is behaving correctly, in fact
I think better, why: when I start the system I have two finger scroll
functionality, then when suspending the system
after waking up the two finger scroll is still functional.
regards;

-- 
Justin P. Mattock
