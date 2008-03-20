Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYCTESu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYCTESu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYCTESj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:18:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbYCTESi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:18:38 -0400
Date: Wed, 19 Mar 2008 21:17:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       morgan@kernel.org, buraphalinuxserver@gmail.com,
       lcapitulino@mandriva.com.br
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
In-Reply-To: <20080320031803.GA23254@sergelap.austin.ibm.com>
Message-ID: <alpine.LFD.1.00.0803192115370.3020@woody.linux-foundation.org>
References: <20080319165635.GH5935@sergelap.ibm.com> <20080319164601.d105e3df.akpm@linux-foundation.org> <alpine.LFD.1.00.0803191912360.3020@woody.linux-foundation.org> <20080320031803.GA23254@sergelap.austin.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Serge E. Hallyn wrote:
> 
> Right, that was against
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> which doesn't yet have smack.  I should've been clear about that.

Ok, now I'm _really_ confused. I have smack in my tree, it got merged 
before -rc1.

So any patch that is against some version without smack is not a patch 
against a -git tree for the last several weeks.

Me confused.

		Linus
