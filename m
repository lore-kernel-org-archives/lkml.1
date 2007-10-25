Return-Path: <linux-kernel-owner+w=401wt.eu-S1762658AbXJYXxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658AbXJYXxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXJYXw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:52:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbXJYXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:52:57 -0400
Message-ID: <47212C42.5010200@zytor.com>
Date: Thu, 25 Oct 2007 16:52:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 3/6] x86: unification of i386 and x86_64 Kconfig.debug
References: <20071025195644.GA14501@uranus.ravnborg.org>	<20071025200434.GD14501@uranus.ravnborg.org>	<86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com> <20071025163541.ee081c26.rdunlap@xenotime.net>
In-Reply-To: <20071025163541.ee081c26.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> It doesn't do that.  EARLY_PRINTK for x86_64 lives in
> arch/x86_64/Kconfig (i.e., a different file).
> 
> Patches welcome.
> 

I think Sam's patchset already takes care of that.

	-hpa
