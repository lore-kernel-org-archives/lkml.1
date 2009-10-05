Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZJESwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZJESwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZJESwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:52:25 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51096 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZJESwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bD2yUXhVczV/b6Unpz44VwSEwIarETlCFluTZGwsnKdTLzpdhAHjjFw71BnBhIwHpd
         vtFGGCN1/xJJss1tZxjCQkqvfJ84R+J/JVrlXMCMSqnfFV+2GcqJwwBZWHYNLOZo11dW
         HpWupzFc51Rtl+IMSGiTzhj/Q9TMm5J5qNBIk=
MIME-Version: 1.0
In-Reply-To: <1254758425.26976.126.camel@twins>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	 <4AC060AE.1090401@gmail.com>
	 <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
	 <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
	 <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com>
	 <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
	 <1254758425.26976.126.camel@twins>
Date: Mon, 5 Oct 2009 11:51:46 -0700
Message-ID: <55a4f86e0910051151y26ec6f92m541a8f1f5f323a14@mail.gmail.com>
Subject: Re: [PATCH] x86: Generate cmpxchg build failures
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strictly speaking isn't there a cmpxchg8b on newer than ancient cpus...

I'm guessing that it's deliberately not supported/used?

Maciej
