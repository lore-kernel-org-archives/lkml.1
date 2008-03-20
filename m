Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYCTCQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYCTCQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYCTCQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:16:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYCTCQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:16:32 -0400
Date: Wed, 19 Mar 2008 19:13:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       morgan@kernel.org, buraphalinuxserver@gmail.com,
       lcapitulino@mandriva.com.br
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
In-Reply-To: <20080319164601.d105e3df.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803191912360.3020@woody.linux-foundation.org>
References: <20080319165635.GH5935@sergelap.ibm.com> <20080319164601.d105e3df.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Andrew Morton wrote:
> 
> umm,
> 
> security/smack/smack_lsm.c: In function 'smack_task_kill':
> security/smack/smack_lsm.c:1122: error: implicit declaration of function 'cap_task_kill'

Serge, can you resend with that fixed and the tested-by added?

		Linus
