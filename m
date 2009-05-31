Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZEaMRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZEaMRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 08:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZEaMQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 08:16:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:42519 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZEaMQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 08:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=diw4q0YxH15UJmK+p70YKhWvbbqVqe+/BmJLoLYHoXGHYWuKQsQlEPmRvn/pKiiS/U
         ySgb0qoQx96e0MkenqxUSSGmGbofBuk9q/QQryb0BCqOA7EKpt0g2kTJ+I6Wsx8by30w
         ve4Ii088OTRWoTDN12NNhRXOzg/0jTixTWX2M=
MIME-Version: 1.0
In-Reply-To: <20090531115828.GB10598@oblivion.subreption.com>
References: <20090530082048.GM29711@oblivion.subreption.com>
	 <20090530180333.GH6535@oblivion.subreption.com>
	 <20090530182113.GA25237@elte.hu>
	 <20090530184534.GJ6535@oblivion.subreption.com>
	 <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com>
	 <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
	 <20090530213311.GM6535@oblivion.subreption.com>
	 <84144f020905310017o3c2b8c52s7d62187cf794e854@mail.gmail.com>
	 <20090531115828.GB10598@oblivion.subreption.com>
Date: Sun, 31 May 2009 15:16:55 +0300
X-Google-Sender-Auth: 74acc061ef39dd2c
Message-ID: <84144f020905310516x692bd870vfbbfc1e734e57326@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Larry H." <research@subreption.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 2:58 PM, Larry H. <research@subreption.com> wrote:
> Thanks for coming to the conclusion that unconditional memory
> sanitization is the correct approach.
>
> I thought this had been stated numerous times before in this thread. Are
> you serious about your responses or you are just clowning around? It's
> amusing, I give you that much.

So is this the same Larry that was able to have a productive and civil
discussion on #mm on IRC where he wanted me to ACK his patches? Or did
his evil identical twin take over the keyboard?

But anyway, enough is enough, and I really am not interested in this
discussion. I wish you the best of luck getting your patches merged. I
suspect you're gonna need it.

                                 Pekka
