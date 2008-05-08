Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYEHCMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYEHCMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYEHCMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:12:07 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34371 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbYEHCMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:12:03 -0400
Message-ID: <4822619D.5020502@keyaccess.nl>
Date: Thu, 08 May 2008 04:12:45 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: enable PAT support on AMD Duron model 7
References: <48210A71.1060409@keyaccess.nl>	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	<20080507124650.GD29935@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>	<48221AE3.6020602@keyaccess.nl>	<482233F0.7040000@zytor.com>	<48224318.8020209@keyaccess.nl>	<48224361.5080102@zytor.com>	<48224507.8010102@keyaccess.nl>	<alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>	<48224930.9030901@keyaccess.nl>	<48225DEC.2030502@keyaccess.nl>	<48225F95.3020205@keyaccess.nl> <20080507190848.43baaa7f@infradead.org>
In-Reply-To: <20080507190848.43baaa7f@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 04:08, Arjan van de Ven wrote:

>> x86: enable PAT support on AMD Duron model 7
>>
>> PAT support seems to work well on AMD Duron model 7. Enable it.
> 
> have you read the errata sheets for this one?
> have you tried various cachability/mtrr combinations (with a new
> enough X)?
> 
> just booting doesn't say much if the feature won't just randomly
> tripple fault later on

No, I haven't, but it's the same thing Yinghai sent to me earlier.
Shouldn't he have? Any indications that it might not work?

Rene.
