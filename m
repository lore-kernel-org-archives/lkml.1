Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXHVDP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXHVDP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbXHVDPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:15:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:54167 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbXHVDPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ms/LFmQpMnlpvH+GGADT7M7UmUWfdTHcdtVbKGKQRyrJxDo1UVwBZQBU2bWVkDU6dzGGb9yr4LRtg49In0zZd5laUtcd2crWi602qRb5qyyf7XmJuQ/d7FnZUiXnbhK2qNvj9SEs4b6cCnflJppVTHaW21WNvsScyGCzv1UnS6c=
Message-ID: <5d6222a80708212015w260a2fcdr64227eb740b8d933@mail.gmail.com>
Date: Wed, 22 Aug 2007 00:15:46 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Noud Aldenhoven" <jwaixs@gmail.com>
Subject: Re: How to learn Linux Kernel Programming
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cb63d1e10708211229n18cc154ep43912a671ca1bfee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb63d1e10708211228u383240a2l4af811f72b8858c0@mail.gmail.com>
	 <cb63d1e10708211229n18cc154ep43912a671ca1bfee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Noud Aldenhoven <jwaixs@gmail.com> wrote:

> I'm a simple Math/Computer Science student and would like to learn
> more about linux and it's kernel.
> To be more precise, I'd to learn how to program in the linux kernel
> and maybe become a developer,
> if everything goes fine.
> But where do I start? Almost all information I found on the Internet
> if from before 2005 and I think that
> means it's out-of-date. Are there up-to-date documentations that are
> use full to read and explain how
> the kernel is build. (for example, is /usr/src/linux/Documentation a
> use full dir?)

Besides the sources already mentioned, there are a couple of quite
good books. I know at least Robert Love's Linus Kernel Development, by
O'Reilly, Rubini et. al. Linux Device Drivers,  and Mel Gorman's about
Virtual Memory, whose exact name I can't recall.

You can also try to start following LKML's flow. Maybe you won't
understand much in the beginning, but your comprehension on the
discussions will improve in the future. (Maybe reading a subsystem
mailing list - less traffic - is a good idea, if you have some
specific interests)

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
