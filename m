Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYFYDSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYFYDSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYFYDS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:18:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:63485 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbYFYDS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rznGASEIJPYov+0SRLQCGdfoH3BkXI2niI+HinXfDDd8G9l8ULnVSplDmAOy/2q+iN
         QbG4eBKQO9QFTIJePhzeherHNAaOFu61G8REpdsoZGuCCsCxMiXzJzqQBzSrGEBpwXrQ
         2cjjC9o+8J8Fy82KXjW1nMd2uChZ98fQmoNSc=
Message-ID: <aa79d98a0806242018h740adb55y54988fff945decf7@mail.gmail.com>
Date: Wed, 25 Jun 2008 07:18:27 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       macro@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] x86: perfctr-watchdog.c - coding style cleanup
In-Reply-To: <20080624204311.GA3346@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080624161624.124913675@gmail.com>
	 <48611ec1.2234440a.679b.1a7d@mx.google.com>
	 <20080624163622.GA8219@elte.hu> <20080624164533.GA19623@cvg>
	 <20080624204311.GA3346@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot, Ingo

On 6/25/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> [Ingo Molnar - Tue, Jun 24, 2008 at 06:36:22PM +0200]
>> |
>> | * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> |
>> | > Just some code beautification. Nothing else.
>> |
>> | applied, thanks Cyrill.
>> |
>> | note, your mailer sets the wrong timestamps:
>> |
>> | | Date: Thu, 01 Jan 1970 03:00:01 +0300
>> | | From: Cyrill Gorcunov <gorcunov@gmail.com>
>> |
>> | i'll edit them out of your patches so that Git doesnt get bogus dates.
>> |
>> | 	Ingo
>>
>> Thanks Ingo, I've mentoined in 'reply' mail for first message in
>> series that somehow happened that date was screwed up. I can resent
>> the series if needed.
>
> no need to resend, fixed it all up :-)
>
> 	Ingo
>
