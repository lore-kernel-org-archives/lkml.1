Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbZATNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbZATNp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZATNpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:45:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:36547 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756151AbZATNpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:45:15 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/Uhx1KZ2rUU1ArhoTR6ylKw+xOA4oiKLyjMbKj/D
	FW2xuGM73cGCAs
Message-ID: <4975D566.2030105@fisher-privat.net>
Date: Tue, 20 Jan 2009 14:45:10 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug #12417] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.Ie.A-QdJB@chimera> <20090120074758.GB26284@elte.hu>
In-Reply-To: <20090120074758.GB26284@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12417
>> Subject		: glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
>> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
>> Date		: 2009-01-06 18:46 (14 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
>> References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
>> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> 
> is it still broken with the current lineup of x86 fixes:
> 
>   git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> 
> ?
> 
> 	Ingo
> --

This patch solve the bug for my old system.
