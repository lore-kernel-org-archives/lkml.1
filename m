Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0CDPao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:30:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0CDPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:30:43 -0500
Message-ID: <4B8FD202.3020507@redhat.com>
Date: Thu, 04 Mar 2010 10:30:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 13/14] x86: Move MAX_INSN_SIZE into asm/insn.h
References: <20100304140046.596569763@chello.nl> <20100304140100.923774125@chello.nl>
In-Reply-To: <20100304140100.923774125@chello.nl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Since there's now two users for this, place it in a common header.
> 
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you,


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
