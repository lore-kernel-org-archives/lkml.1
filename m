Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZEYXEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZEYXEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZEYXEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:04:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZEYXEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:04:22 -0400
Message-ID: <4A1B23AB.7090204@zytor.com>
Date: Mon, 25 May 2009 16:03:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>,
       Suresh Siddha <suresh.d.siddha@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain> <alpine.LFD.2.01.0905251550320.3435@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905251550320.3435@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 25 May 2009, Linus Torvalds wrote:
>> Now you made it do two different "on_each_cpu" things. Maybe it doesn't 
>> matter, but it just seems wrong.
> 
> Btw, I pulled, I just wanted to note that I don't think this was done 
> optimally/cleanly.
> 

Understood.  Do you want a fix now or for .31?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

