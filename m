Return-Path: <linux-kernel-owner+w=401wt.eu-S1765668AbXHFSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765668AbXHFSiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXHFSiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:38:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:55660 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbXHFSiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:38:10 -0400
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
References: <20070803105540.4f85ae09@localhost>
	<20070806074608.GA12415@elte.hu> <20070806103615.4be4670f@localhost>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Aug 2007 21:32:29 +0200
In-Reply-To: <20070806103615.4be4670f@localhost>
Message-ID: <p73vebslar5.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> writes:
> 
>  I'll manage to test it then. Do you have a test-case or has any
> suggestion?

LTP has some simple test cases for modify_ldt

-Andi
