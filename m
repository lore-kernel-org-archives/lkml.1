Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYC0Vv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYC0Vv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYC0VvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:51:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYC0VvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:51:19 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
References: <20080327132057.449831367@polymtl.ca>
	<20080327154053.GA5890@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 27 Mar 2008 17:49:35 -0400
In-Reply-To: <20080327154053.GA5890@elte.hu> (Ingo Molnar's message of "Thu, 27 Mar 2008 16:40:53 +0100")
Message-ID: <y0mprtf3ki8.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>> After a few RFC rounds, I propose these markers for 2.6.26. They 
>> include work done after comments from the memory management community. 
>> Most of them have been used by the LTTng project for about 2 years.
>
> [...]
> so we optimistically used markers in ftrace (see sched-devel.git) for 
> the scheduler, and i was shocked about marker impact:

Do you have any *time* measurements?


- FChE
