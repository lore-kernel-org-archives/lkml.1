Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZBDQCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZBDQCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZBDQCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:02:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:34536 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752370AbZBDQCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:02:33 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/COuR7IgjCIopeDW99ckGgYFfg1mTO7+3V+d+FDl
	j28tpl9VtqAG1E
Message-ID: <4989BC16.4080602@fisher-privat.net>
Date: Wed, 04 Feb 2009 17:02:30 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #12417] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.dX.QwYiJB@chimera> <20090204134612.GB17024@elte.hu>
In-Reply-To: <20090204134612.GB17024@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
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
>> Date		: 2009-01-06 18:46 (30 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
>> References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
>> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>> 		  Ingo Molnar <mingo@elte.hu>
>>
> 
> this should be fixed in latest -git. Alexey, can you confirm?
> 
> 	Ingo

I confirm it. It working  great with latest git 2.6.29-rc3-00495-gdcf6a79.
	Alexey
