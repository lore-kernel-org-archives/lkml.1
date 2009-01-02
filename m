Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZABXcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZABXcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbZABXcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:32:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906AbZABXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:32:12 -0500
Date: Fri, 2 Jan 2009 15:31:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
In-Reply-To: <20090102203839.GA26850@elte.hu>
Message-ID: <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Jan 2009, Ingo Molnar wrote:
> 
> Linus, would you like to pull that, despite the pending regressions? Can 
> send a pull request right away.

No, if there are known pending regressions, please get those fixed first.

		Linus
