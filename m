Return-Path: <linux-kernel-owner+w=401wt.eu-S1030823AbXCNJhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823AbXCNJhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXCNJhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:37:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:36113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030824AbXCNJhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:37:04 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
References: <20070314050819.536207642@goodmis.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Mar 2007 11:36:08 +0100
In-Reply-To: <20070314050819.536207642@goodmis.org>
Message-ID: <p73slc8863r.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> 
> So I spent last night hacking up something to try to make a common ground
> for all code that is shared between x86_64 and i386.  I called this
> 
>    arch/x86

NACK. I think the current ways work just fine. 

-Andi

