Return-Path: <linux-kernel-owner+w=401wt.eu-S935389AbZDIQ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935389AbZDIQ6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759165AbZDIQ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:58:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54136 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZDIQ60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cKVAn1DhLs1XukBOuH+ljZZjWqmaTBE5iyCP04jT6fiuM2BLSr8V+MA9NxFT2wn0Rm
         CELxqOdmGNYdYVIl52cLPtCz/JWCByN8XLOWDUaumwPQnSOM9+LuSPIrE8eyGLLP4ied
         Yv7c0uoVQsC2/959NoUS6QDNx2mWISVut2N/k=
MIME-Version: 1.0
In-Reply-To: <20090409185320.4ccba2df@daedalus.pq.iki.fi>
References: <49DD6E2B.6090200@cn.fujitsu.com>
	 <tip-66bb74888eb4bef4ba7c87c931ecb7ecca3a240c@git.kernel.org>
	 <20090409185320.4ccba2df@daedalus.pq.iki.fi>
Date: Thu, 9 Apr 2009 19:58:24 +0300
X-Google-Sender-Auth: 1879e51380b474bd
Message-ID: <84144f020904090958j2b246036j7f033e5f72c0b33@mail.gmail.com>
Subject: Re: [tip:tracing/urgent] tracing: consolidate documents
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pekka Paalanen <pq@iki.fi>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 6:53 PM, Pekka Paalanen <pq@iki.fi> wrote:
> On Thu, 9 Apr 2009 05:30:47 GMT
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> Commit-ID:  66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
>> Gitweb:     http://git.kernel.org/tip/66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
>> Author:     Li Zefan <lizf@cn.fujitsu.com>
>> AuthorDate: Thu, 9 Apr 2009 11:40:27 +0800
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Thu, 9 Apr 2009 07:28:10 +0200
>>
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
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> Acked-by: Pekka Paalanen <pq@iki.fi>
>
> Hey, I didn't say anything yet. Maybe you meant Enberg?
> There are at least two Pekkas here :-)

Haha! Yeah, I acked the kmemtrace part so Ingo is probably just confused. :-)
