Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYD0CA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYD0CA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYD0CAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:00:49 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:30608 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYD0CAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UadxTPe7MGQcPj1XhyjsIt6ua8fGeudQAU/ZWwn0ehuD+Lv7TRXP7/kOIjfhRSST06OO7ZZQ05//4AxNDJe9WuoGKE/Pg9wml1dLRa7kYj7RL7gxApZfl0sgtbTOUKRQZyYnmZqBCT2Fhl5lHfnxSHH7FuM3DkAkRDXJp/qFfus=
Message-ID: <dd18b0c30804261900m1a2edebld6a796e1de85c19e@mail.gmail.com>
Date: Sun, 27 Apr 2008 02:00:47 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Bernard Pidoux" <bpidoux@free.fr>
Subject: Re: spinlock lockup on CPU#0
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200804270215.23739.bpidoux@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262333.39383.bpidoux@free.fr>
	 <200804270215.23739.bpidoux@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 12:15 AM, Bernard Pidoux <bpidoux@free.fr> wrote:
> Hi,
>
>  cpu_idle bug is also present in 2.6.24.4 kernel.
>
>  I hope this helps.
>
>  Bernard Pidoux
>
>
>
>
>

Cool, you're welcome.
I've just pulled the latest update and rebooted, eveything looks good
except for my wireless
just spent two hours trying to tweak it to go, but can't figure out
what is happening
madwifi is   giving me a *** TARGET i386-elf is invalid.
aside from that is there a patch for athk5 for the macbook's?
if not, thats O.K. I'm going to have a look into what I might have
wrong on my part maybee (make) is too old.
regards;

-- 
Justin P. Mattock
