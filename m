Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbZE3L2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbZE3L2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZE3L16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:27:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:62218 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbZE3L15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nOEd2cqNE7qZMbw7M9j6WHbu9QSHMje1eM0DbrgyULKVTLqXntFjAyISQ7v9dE8y8T
         wW3hTtRBCA6TdTNXezpTvRj02xseOWmY1TunjM9ILQyIbV7VhoSI1tUo/OebW8Erj8+z
         OjMWYX0Oi0OlqUon5XD3FPPE5iWeIb/wNkCNY=
MIME-Version: 1.0
In-Reply-To: <20090530094031.GB16913@elte.hu>
References: <tip-efb3d17240d80e27508d238809168120fe4b93a4@git.kernel.org>
	 <49b7c2350905291715v2ff53a96o98a0fd195ee27dc9@mail.gmail.com>
	 <4A207C76.20502@kernel.org> <20090530094031.GB16913@elte.hu>
Date: Sat, 30 May 2009 20:27:58 +0900
Message-ID: <49b7c2350905300427j2fd4b90fr47a39dc41ce53a75@mail.gmail.com>
Subject: Re: [tip:perfcounters/core] perf_counter: Fix COMM and MMAP events 
	for cpu wide counters
From: GeunSik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 6:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
> -tip is to signal the 'cutting edge/summit' of the trees we are
> maintaining and working on. "define:tip" on google gives:
>
> tip:
>  [...]
>  peak: the top or extreme point of something (usually a mountain or
>  hill); "the view from the peak was magnificent"; "they clambered
>  to the tip of Monadnock"; "the region is a few molecules wide at
>  the summit"
>
>> T: Thomas
>> I: Ingo
>> P: hpa
>
> That secondary meaning is valid too ;-)
>
>        Ingo
>
Thanks Yinghai and Ingo.
I'm so happy to hear about "-tip" meaning.

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
--
