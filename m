Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZKTAhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZKTAhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbZKTAhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:37:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbZKTAhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:37:18 -0500
Message-ID: <4B05E4A5.4000501@redhat.com>
Date: Thu, 19 Nov 2009 19:36:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v2 0/3] tracepoint: Add signal events
References: <20091118211609.20207.55487.stgit@dhcp-100-2-132.bos.redhat.com> <20091119193814.GB2625@redhat.com>
In-Reply-To: <20091119193814.GB2625@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Jason Baron wrote:
> On Wed, Nov 18, 2009 at 04:16:09PM -0500, Masami Hiramatsu wrote:
>> Hi,
>>
>> These patches add signal related tracepoints including
>> signal generation, delivery, and loss. First patch also
>> moves signal-sending tracepoint from events/sched.h to
>> events/signal.h.
>>
>> Changes in v2
>> - Add siginfo arguments
>>
>
> hi Masami,
>
> It would be really great if you could add docbook style comments to
> your tracepoints. Here's the initial path I posted for the irq chapter:
> http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02651.html
>
> So you could add a new chapter for signals.

Ah, that's a good suggestion. I'll add it next version.

Thank you,

>
> The current tracepoint docbook can be viewed at:
>
> http://www.kernel.org/doc/htmldocs/tracepoint/
>
> thanks,
>
> -Jason

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

