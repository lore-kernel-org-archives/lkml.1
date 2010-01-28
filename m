Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293Ab0A1FVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0A1FVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 00:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465Ab0A1FVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 00:21:21 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37172 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0A1FVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 00:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YerWeyX8qQ8WntLe1txaCHmvmk6Yubkgs2eGWsihudmNfd41hmwpY8ABL+NjErH2xn
         /UN9kAN45nBxiiUZQqA06xJUUeLSnRVqUc6NFGa1sI4mtBY+2Elyg2H4NJy/l8leCbDQ
         rRW1SLQ4hWJpt53en8U+rFckptS15YKRUHHUA=
MIME-Version: 1.0
In-Reply-To: <20100127132212.cd43cd94.akpm@linux-foundation.org>
References: <20100118044142.GS12666@kryten>
	 <tip-43f85eab1411905afe5db510fbf9841b516e7e6a@git.kernel.org>
	 <661de9471001270534ve6f7bf0nb58ef58f9a6ff10e@mail.gmail.com>
	 <20100127132212.cd43cd94.akpm@linux-foundation.org>
Date: Thu, 28 Jan 2010 10:51:16 +0530
X-Google-Sender-Auth: c5c3305d54894d49
Message-ID: <661de9471001272121v70870f0dvc7bd2d4e95dc860a@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: cpuacct: Use bigger percpu counter 
	batch values for stats counters
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > __ __ __ __ __ __ __ __ca = ca->parent;
>> > __ __ __ __} while (ca);
>> > __ __ __ __rcu_read_unlock();
>
> ^^ your email client inexplicably fills emails with 0xa0
>

I am going to be changing my email client soon, back to the good old
text client.

>> IIRC, Andrew picked up this patch as well and applied some checkpatch
>> fixes too..
>
> No, I have no changes.
>

Sorry, I was confused, the changes you had were for getdelays.c

> Last I heard, Anton was "working on a useful comment" and will be
> redoing the patch.

Yep, lets wait on him.

Three Cheers,
Balbir
