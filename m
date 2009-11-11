Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZKKT1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZKKT1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbZKKT1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:27:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758591AbZKKT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:27:48 -0500
Date: Wed, 11 Nov 2009 11:25:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH percpu#for-linus] percpu: restructure pcpu_extend_area_map()
 to fix bugs and improve readability
In-Reply-To: <4AFA7A83.7080703@kernel.org>
Message-ID: <alpine.LFD.2.01.0911111124590.31845@localhost.localdomain>
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu>
 <4AFA7A83.7080703@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Nov 2009, Tejun Heo wrote:
>
> I've also put this patch on percpu#for-linus but routing this through
> tip would be safer.  Went through usual battery of tests and also
> verified both bugs are fixed.  Ingo, can you please put this into tip?

Looks good to me. Ack.

		Linus
