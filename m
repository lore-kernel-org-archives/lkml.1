Return-Path: <linux-kernel-owner+w=401wt.eu-S937552AbZDJAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937552AbZDJAgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937139AbZDJAfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:35:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60560 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S936976AbZDJAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:35:51 -0400
Message-ID: <49DE9492.2080703@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 08:36:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [tip:tracing/urgent] tracing: consolidate documents
References: <49DD6E2B.6090200@cn.fujitsu.com>	<tip-66bb74888eb4bef4ba7c87c931ecb7ecca3a240c@git.kernel.org> <20090409185320.4ccba2df@daedalus.pq.iki.fi>
In-Reply-To: <20090409185320.4ccba2df@daedalus.pq.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> tracing: consolidate documents
>>
>> Move kmemtrace.txt, tracepoints.txt, ftrace.txt and mmiotrace.txt to
>> the new trace/ directory.
>>
>> I didnt find any references to those documents in both source
>> files and documents, so no extra work needs to be done.
> 
> There is one reference: kernel/trace/Kconfig, search for MMIOTRACE.
> Fix that, and you have my ack on the mmiotrace.txt part.
> 

Oh, I forgot to grep Kconfig.. There is also a reference to
kmemtrace.txt in Kconfig. I'll fix it.
