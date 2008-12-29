Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYL2LUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYL2LUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYL2LUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:20:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:50809 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYL2LUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=p6s+rjkXQKHIeidz3Gr3jOut91ZY1LW9Low6I2BSSb2VrdcTPVQPZz9JM9FJXLeAGN
         9ar0kpTfqqjkFm+ckX8jjBo0UEczpNkiq1m+pn9SthuvAVsrhhBoMwjBf/hLcThBB4X1
         oEqWzcU01iS+kniRlvhrWhWeuWMcSX9O9TAwQ=
Message-ID: <2f11576a0812290320m27d08a6fr3d43093ee53f74da@mail.gmail.com>
Date: Mon, 29 Dec 2008 20:20:34 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <20081229110954.GB5065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
	 <20081227173839.GA9793@elte.hu>
	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
	 <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu>
	 <86802c440812281601j57fe5ecdif4b63b72280c65cd@mail.gmail.com>
	 <2f11576a0812290039t11ca9b76sf305e82003ac607@mail.gmail.com>
	 <20081229110954.GB5065@elte.hu>
X-Google-Sender-Auth: e5aaa513ba1aa81e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm sad ;-)
>>
>> Why you use printk? if develper use non-x86 machine, they will see
>> perfectly worthless debug messages...
>
> yes. If you can reproduce the problem then please check the version in
> tip/master:

Unfortunately, No I can't.



>  http://people.redhat.com/mingo/tip.git/README
>
> it doesnt include any needless printks.
>
>        Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
