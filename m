Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYHTAYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYHTAYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYHTAYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:24:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:24100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYHTAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tGtVLwq62bL+fBeUvvbPKcdN93NaUm1KZP67mXHZYXt08nO1GJj59lrMvYYcso5yfK
         IRe966C1fikjMm9Wt89En0anG4wnuo1KPV61mGp3y56beKQI7FRPtoQ3rof5AtOaE0Hs
         xXTncfoTXePkqH2X7qgQO99Kx/4I7yGAZ+Cxw=
Message-ID: <86802c440808191724j68f50b1fx7b2488963fcf96fd@mail.gmail.com>
Date: Tue, 19 Aug 2008 17:24:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 0/5] merge io_apic_xx.c -- fix
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080819152156.c79f31e4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080816133554.GB11063@elte.hu>
	 <20080819152156.c79f31e4.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 3:21 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sat, 16 Aug 2008 15:35:54 +0200 Ingo Molnar wrote:
>
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> >     merge io_apic_xx.c
>> >
>> > Thanks
>>
>> applied to tip/irq/sparseirq - thanks!
>
>
> Are there patches in the io_apic series to fix these warnings in linux-next?? ::
>
>
> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64
>
>
> and
>
> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
>

No

after get io_apic_xx.c merged.

YH
