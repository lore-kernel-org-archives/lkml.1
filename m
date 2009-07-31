Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZGaQlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZGaQlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZGaQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:41:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZGaQlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:41:12 -0400
Message-ID: <4A731E85.6090301@zytor.com>
Date: Fri, 31 Jul 2009 09:40:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timers fixes for 2.6.31
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain> <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain> <20090731123711.GA5421@elte.hu>
In-Reply-To: <20090731123711.GA5421@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2009 05:37 AM, Ingo Molnar wrote:
> 
> I've pushed out the fix. I did two minor (non-functional) edits to 
> the commit: fixed the comment style to match that of the rest of 
> clocksource.h and improved the commit log a tiny bit. Find the 
> updated pull request below.
> 

OK, won't worry about it, then.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

