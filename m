Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbZADR2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbZADR2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZADR17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:27:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:61416 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZADR16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jduXEFLMpBrp8pWDWLTsmfhbtxQ/xzCGjkw0o3Lq12hS4IiJ91GGzoy+njsImB6Ahm
         /tdBd+7mpcR7N5JFKo3oMYTajMcKDAC+imhamRapbKPoWanfy+jq8DY6ZofBV5rxqzpV
         rTappaex8TBGjW9Chm1FRMbfK7stooiaRn890=
Message-ID: <3f9a31f40901040927h5c99023dha34e1dd566673383@mail.gmail.com>
Date: Sun, 4 Jan 2009 22:57:57 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090104172114.GA32425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231066898.27852.29.camel@jaswinder.satnam>
	 <20090104172114.GA32425@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sun, Jan 4, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
>
>> Impact: cleanup, fix style problems, more readable
>>
>> Fixes style problems:
>> WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
>> WARNING: Use #include <linux/percpu.h> instead of <asm/percpu.h>
>> WARNING: Use #include <linux/topology.h> instead of <asm/topology.h>
>> WARNING: externs should be avoided in .c files
>> ERROR: code indent should use tabs where possible
>>
>> total: 2 errors, 4 warnings
>
> doesnt build on some configs:
>

Very strange. I have tested this on X86_32 (UP and SMP) and X86_64 SMP

Can you please provide me config file where it fails.

Thank you,

JSR.
