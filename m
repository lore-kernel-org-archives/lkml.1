Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZJBJNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZJBJNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZJBJNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:13:18 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:49289 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbZJBJNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:13:17 -0400
Message-ID: <4AC5C42E.9070909@msgid.tls.msk.ru>
Date: Fri, 02 Oct 2009 13:13:18 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14270] Cannot boot on a PIII Celeron
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>	 <COE24pZSBH.A.7sH.xMTxKB@chimera> <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com>
In-Reply-To: <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On 10/1/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.30 and 2.6.31.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>> be listed and let me know (either way).
> 
> Michael has been asked to bisect it (if possible). I cant reproduce it
> in kvm unfortunately.

Yes, and that's what I'll be trying to do shortly.
I had other issues to sort out and wasn't able to
get to it in few last days.

Also I've a few other suspects.  For example, in this .31
config I changed from bzip to lzma compression - and that's
where (or near) kernel is rebooting.

/mjt

>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14270
>> Subject		: Cannot boot on a PIII Celeron
>> Submitter	: Michael Tokarev <mjt@tls.msk.ru>
>> Date		: 2009-09-28 15:26 (4 days old)
>> References	: http://marc.info/?l=linux-kernel&m=125415160524110&w=4
>>
>>
>>

