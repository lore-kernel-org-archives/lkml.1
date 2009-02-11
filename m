Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZBKOE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZBKOE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZBKOES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:04:18 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57999 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbZBKOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KUKunK9DF43bxSeJqPNwBrU9DiOypcJlvKgVAqZ91hLmK/wj4IZCY9qkHElR99okV+
         5FB32xtY8uzvCPVV4aRcFrlLHoY6T/+/sW1r1CWkHfAcPsx1XrcjrE6va50VewTZIq42
         CDQ8hhR0rEOqrGWhrHp2FQW6qqPrqWFfr9DS8=
MIME-Version: 1.0
In-Reply-To: <20090210141405.GA16147@elte.hu>
References: <a5f59d880902100542x7243b13fuf40e7dd21faf7d7a@mail.gmail.com>
	 <20090210141405.GA16147@elte.hu>
Date: Wed, 11 Feb 2009 22:04:16 +0800
Message-ID: <a5f59d880902110604g40cf17b5w92431f60e6f16fa4@mail.gmail.com>
Subject: Re: Using module private memory to simulate microkernel's memory 
	protection
From: Pengfei Hu <hpfei.cn@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hm, are you aware of the kmemcheck project?
>
>        Ingo
>

Frankly, I only know this project's name. Just when I nearly finished
this patch, I browsed http://git.kernel.org/ first time. I am only a
beginner in Linux kernel. Maybe I should first discuss before write
code. But I think it is not too late.

Can you tell me more about this project? I realy appreciate it.
