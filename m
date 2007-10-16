Return-Path: <linux-kernel-owner+w=401wt.eu-S1765728AbXJPKNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765728AbXJPKNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbXJPKNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:13:24 -0400
Received: from ns.kkc.fi ([62.148.199.203]:48109 "EHLO smtp.kkc.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822AbXJPKNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:13:23 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 06:13:23 EDT
Message-ID: <47148CAC.8060603@mandriva.org>
Date: Tue, 16 Oct 2007 13:04:28 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.24
References: <20071015141723.GA29486@elte.hu>
In-Reply-To: <20071015141723.GA29486@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar skrev:
> Linus, please pull the latest scheduler git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> It contains lots of scheduler updates from lots of people - hopefully 
> the last big one for quite some time. Most of the focus was on 
> performance (both micro-performance and scalability/balancing), but 
> there's the fair-scheduling feature now Kconfig selectable too. Find the 
> shortlog below.
> 


How does this one compare to the v22 you released earlier ?

I'm thinking of backporting any fixes/optimizations to 2.6.22
(and possibly 2.6.23)

--
Thomas
