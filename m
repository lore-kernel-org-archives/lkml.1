Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZCHTaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZCHTaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 15:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZCHTaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 15:30:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:3026 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZCHTaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 15:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=h0Dk5ORKvDA35rc0RHfDWU94mw0WZeYWLtA6QrAzddihD+Fb4rUCU9GB3sYnOArLQL
         8j2P5dkCn0KRZDIH38me2SpwTNTdvaJjdztwu0GWI/Or4MCQV0vWGHifqhH56c72aq6t
         qs21F5IdpmP4ok//42Br7fQokT0LRdEvuHms8=
MIME-Version: 1.0
In-Reply-To: <20090308185834.GD28169@elte.hu>
References: <49B1C47C.5080401@kernel.org>
	 <tip-4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e@git.kernel.org>
	 <20090308185834.GD28169@elte.hu>
Date: Sun, 8 Mar 2009 12:30:02 -0700
X-Google-Sender-Auth: 6a154db97f196464
Message-ID: <86802c440903081230y4abc548m16bb722863ea0b1a@mail.gmail.com>
Subject: Re: [tip:kmemcheck] x86: introduce bootmem_state
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org, tglx@linutronix.de,
       Vegard Nossum <vegard.nossum@gmail.com>,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 8, 2009 at 11:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Commit-ID:  4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
>> Gitweb:     http://git.kernel.org/tip/4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
>> Author:     "Yinghai Lu" <yinghai@kernel.org>
>> AuthorDate: Fri, 6 Mar 2009 16:49:00 -0800
>> Commit:     Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sun, 8 Mar 2009 19:43:09 +0100
>>
>> x86: introduce bootmem_state
>>
>> Impact: cleanup
>
> Note, this cleanup ended up in the tip:kmemcheck branch because
> it modifies the same code so there's dependencies.

not sure. it seems it should be with tip/x86/mm

YH
