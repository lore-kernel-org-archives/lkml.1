Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYHRHl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYHRHl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYHRHlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:41:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:39235 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYHRHlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AxoC8alAWNmHt6YtAAteG0RA9MO+ftAJR1zxPbNNdG8bzgqdbcyJqDPQGmQ03zylkI
         mA6teFjDlx/czDidHNvcHrZlOSB0fQYYfURJcFzikFVLiNQQpa5rBVi+T4dLxzIbOzuE
         0wDZ84NSaU86FLL2XSZXh/gkR65DP6/Pe59qY=
Message-ID: <aa79d98a0808180041s596f4d63t3780afedfe781d92@mail.gmail.com>
Date: Mon, 18 Aug 2008 11:41:20 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/9] -tip/apic merging one more series
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
       macro@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080818072432.GA6204@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
	 <86802c440808171453i2869a7f3x1db27307dbec4db7@mail.gmail.com>
	 <aa79d98a0808172122sfab2336ldfcccc88e4316712@mail.gmail.com>
	 <20080818071820.GB17961@elte.hu> <20080818072432.GA6204@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Oh...indeed. Thanks Yinghai! - will fix it today evening.
>> > Ingo drop this patch please (if it was applied).
>>
>> hm, none of these patches has lapic_resume mentioned and current
>> tip/master's version doesnt seem broken so there's nothing to drop.
>
> ah, i see Yinghai's fix. I'll apply that to tip/x86/apic.
>
>        Ingo
>

Thanks Ingo, I'll fetch tip/apic after my workaday complete then
check what is applied what is not and rearrange pathes if needed
and then resend. Ugh... :-)
