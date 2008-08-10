Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYHJSXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYHJSXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 14:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYHJSXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 14:23:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYHJSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 14:23:41 -0400
Message-ID: <489F31FC.9040104@zytor.com>
Date: Sun, 10 Aug 2008 11:22:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #11201] kernel BUG at arch/x86/kernel/io_apic_64.c:357!
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>	<cX_-nNkxKaF.A.AGD.iEjnIB@albercik> <m1sktdsmyy.fsf@frodo.ebiederm.org>
In-Reply-To: <m1sktdsmyy.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.26.  Please verify if it still should be listed and let me know
>> (either way).
> 
> Yep.  There is a patch in -mm.  It seems the process is to wait for Thomas &
> Ingo to get back before we send this to Linus. 
> 

Yes, unfortunately I still don't have enough testing resources to want 
to push this upstream.  I'm queuing it up for submission, though.

	-hpa
