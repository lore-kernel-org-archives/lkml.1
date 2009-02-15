Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZBOIK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZBOIK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 03:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZBOIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 03:10:48 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50802 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZBOIKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 03:10:47 -0500
Message-ID: <4997CDDC.1020103@garzik.org>
Date: Sun, 15 Feb 2009 03:10:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.kkF.Ds0lJB@chimera> <499797FD.5070701@lwfinger.net>
In-Reply-To: <499797FD.5070701@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
>> Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
>> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
>> Date		: 2009-01-23 23:52 (23 days old)
>> References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
>> 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
>> Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
>> 		  Hugh Dickins <hugh@veritas.com>
>> 		  Sergei Shtylyov <sshtylyov@ru.mvista.com>
>> Patch		: http://marc.info/?l=linux-kernel&m=123412278730735&w=4
> 
> This problem is not fixed as of 2.6.29-rc5.

Sergei, what is the latest version of your patch?   According to my 
notes, you and Hugh were going back and forth trading patches, and I 
never saw a final version...

	Jeff




