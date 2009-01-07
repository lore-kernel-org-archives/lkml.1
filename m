Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbZAGPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbZAGPTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZAGPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:19:13 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:50696 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZAGPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VMkGxvKOKOs89DrDlVDczykICB9qH00fDBuFGUK9FoCq2Qm1mhC7k8+PnWZcyIAz8h
         xY/TbPMxTBm3s04SSE18MSmVXqZwH2qudMJtg+ahLQDdosCBPnSXuj5MIZqtV/M0akic
         QvX+Svxsf7Nt8Tlbz+zHhBuORG6B6NPFInsNE=
Message-ID: <3f9a31f40901070719j1349b44fk8f20b3cbb227e9d@mail.gmail.com>
Date: Wed, 7 Jan 2009 20:49:10 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090107151522.GA5341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231329368.17961.29.camel@jaswinder.satnam>
	 <20090107125152.GA3529@elte.hu> <20090107133327.GA4911@elte.hu>
	 <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com>
	 <20090107150351.GB27606@elte.hu> <20090107151223.GA4899@elte.hu>
	 <20090107151522.GA5341@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 8:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> note, i kept these:
>
> 6e5385d: x86: smp.h move prefill_possible_map declartion to cpu.h
> dacf733: x86: smp.h move zap_low_mappings declartion to tlbflush.h
> 7760ec7: x86: smp.h remove obsolete function declaration
>
> as they seem fairly safe.
>

OK, thanks.

I will prepare new lot of remaining 4 patches.

Due to some problem in mailer server it sending my old patches, please
ignore them.

Thanks
--
JSR
