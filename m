Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYEHA37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYEHA37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYEHA3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:29:49 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59724 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYEHA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:29:48 -0400
Message-ID: <482249B2.5000406@keyaccess.nl>
Date: Thu, 08 May 2008 02:30:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805080214070.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805080214070.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 02:21, Thomas Gleixner wrote:

> On Thu, 8 May 2008, Rene Herman wrote:

>> And again, the kernel DOES see that my CPU features PAT, it just refuses
>> to use it.
> 
> Yuck, because your CPU has the PAT feature the kernel has an obligation
> to support it ?
> 
> Nice try.

No, damnit, it does not need to use it, it needs to NOT HIDE IT FROM ME.

Rene.
