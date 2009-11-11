Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZKKMWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZKKMWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:22:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZKKMWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:22:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:38969 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbZKKMWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:22:00 -0500
Message-ID: <4AFAAC32.4020104@kernel.org>
Date: Wed, 11 Nov 2009 21:21:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu>
In-Reply-To: <20091111113147.GB7487@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
>> I was mostly worrying about introducing unrelated bug while changing. 
>> Anyways, one patch it is.  I'll route it through tip as suggested by 
>> Ingo in a few hours.
> 
> Btw., i'd suggest you keep it in your percpu tree as usual and send it 
> to Linus directly - i offered testing for the cleanup patch (and can 
> pull your patch for such a purpose), it doesnt 'have' to go via -tip.

Can you please then pull from the following tree for testing?  I'll
push it to Linus after a couple of days if nothing explodes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

Thanks.

-- 
tejun
