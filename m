Return-Path: <linux-kernel-owner+w=401wt.eu-S1762550AbYBZKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762550AbYBZKar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761618AbYBZKab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:30:31 -0500
Received: from areca.com.tw ([220.130.178.142]:40071 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761352AbYBZKa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:30:29 -0500
Reply-To: <nick.cheng@areca.com.tw>
From: "nickcheng" <nick.cheng@areca.com.tw>
To: "'Nikola Ciprich'" <extmaillist@linuxbox.cz>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       "'Erich Chen'" <erich@areca.com.tw>, <kopi@linuxbox.cz>,
       <kevin34@areca.com.tw>, <billion.wu@areca.com.tw>
Subject: RE: arcmsr & areca-1660 - strange behaviour under heavy load
Date: Tue, 26 Feb 2008 18:30:25 +0800
Organization: areca
Message-ID: <001701c87862$993a44c0$8800a8c0@Nick>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz>
thread-index: Ach4Wi+Jzo2jutZURouO/yDBZlRY8gAB1H5Q
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-OriginalArrivalTime: 26 Feb 2008 10:24:54.0703 (UTC) FILETIME=[D42E63F0:01C87861]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikola,
As I said, we will test on our site.
Our support team will help you to settle the issue.
Sorry for your inconvenience,

-----Original Message-----
From: Nikola Ciprich [mailto:extmaillist@linuxbox.cz] 
Sent: Tuesday, February 26, 2008 5:36 PM
To: Andrew Morton
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nick Cheng;
Erich Chen; kopi@linuxbox.cz
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load

Hi

On Sun, 24 Feb 2008, Andrew Morton wrote:

Hi Andrew,
thanks a lot for reply, I'm attaching requested information.
please let me know if You need more information/testing, whatever.
I'll be glad to help.
BR
nik

>> Areca support doesn't seem to be very interested in the problem :-(
>
> (cc's added)
>
> Please get the machine into this state of memory exhaustion then take
> copies of the output of the following, and send them via reply-to-all to
> this email:
>
> - cat /proc/meminfo
>
> - cat /proc/slabinfo
>
> - dmesg -c > /dev/null ; echo m > /proc/sysrq-trigger ; dmesg -c
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

-- 

