Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbZKMTBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbZKMTBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZKMTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:01:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41622 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbZKMTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=joa81CowziMkA1UEDdvWVHjYng1oIAuOIeCtCe6rBO20mFHGLhvYWQM4oaQYbYPGBH
         D+Jdh0jyn6oBpY6dSXjAUk1senP/nwrFUOHA0M7BAGEYHumhLVgmrNDwmoFCBB4VA3AW
         jdfpTt2NhOEmKYznfrgHY/6Fp9E9VzKMHqSjg=
MIME-Version: 1.0
In-Reply-To: <43e72e890911131059xde0494laa22684f3b8a65b4@mail.gmail.com>
References: <a44ae5cd0911112058s52d59f5dy707633fce9eb3816@mail.gmail.com>
	 <a44ae5cd0911131056i242ca15dmceff81466b897c9e@mail.gmail.com>
	 <43e72e890911131059xde0494laa22684f3b8a65b4@mail.gmail.com>
Date: Fri, 13 Nov 2009 14:01:31 -0500
Message-ID: <a44ae5cd0911131101n29e071ads72d6cc21a457f4a2@mail.gmail.com>
Subject: Re: [ath9k-devel] 2.6.32-rc6-git4 -- BUG kmalloc-8192: Poison 
	overwritten - INFO: Allocated in ath_rxbuf_alloc+0x1c/0x70 [ath] age=526999 
	cpu=1 pid=1275
From: Miles Lane <miles.lane@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 1:59 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 13, 2009 at 10:56 AM, Miles Lane <miles.lane@gmail.com> wrote:
>> I just got this again in 2.6.32-rc7.
>
> How can you trigger it?

I will do my best to determine that and get back to you.
