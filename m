Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZHWVQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZHWVQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 17:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZHWVQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 17:16:30 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51618 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZHWVQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 17:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WszmAwZUOKPAL47iZItH3gyeE1TsgG0ZPFZ4GpfxHKKAevVVT/hTnQ6BQ5LZbcPd/S
         QY+6JQu6ahdY2lv2yEdZi4UGJ/if5huuBaBwS2SsRilc9A/EERWONzfP5zFHBIRvGPM7
         3/IczVVDnAeZZfdI5fqND1E7UWbrUlqq1ovkk=
Date: Sun, 23 Aug 2009 23:16:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/4] tracing: Rename TIF_SYSCALL_FTRACE->_TRACEPOINT
Message-ID: <20090823211625.GH6256@nowhere>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250917125-6174-2-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 09:58:42PM -0700, Josh Stone wrote:
> This thread flag is no longer specific to just ftrace, so
> TIF_SYSCALL_TRACEPOINT may be a more apt name.


Adding Paul Mundt <lethal@linux-sh.org> in Cc, the sh
tree also has the syscalls tracing support (in a seperate
branch).

Thanks.

