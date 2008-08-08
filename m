Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbYHHXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbYHHXH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYHHXHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:07:15 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:10163 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYHHXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AJtn0SAwu7LP8O+gZBlWsdEn71ZHRQY/n3BeiC7jaoRa1Vp/l1UALQR4stqa0V3N9X
         q6r5oDmqQwBUGZPMRKniKXMURCUurJsVA75tqnCgHxQvSFP6H01sjTJqprwnWRJEKfws
         4KPOWPlH+7VKoKohJH8iDig2vB/UJXJf9sEjM=
Message-ID: <86802c440808081607x36784e73n660a38a13609bada@mail.gmail.com>
Date: Fri, 8 Aug 2008 16:07:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 01/42] 8250: Remove NR_IRQ usage
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@redhat.com>
In-Reply-To: <m1ej4zyvww.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
	 <m1ej4zyvww.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 3:38 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> From: Alan Cox <alan@redhat.com>
>>
>> Works on my test box with a quick test.
>>
>> From: Alan Cox <alan@redhat.com>
>
> You missed the bug fix...
>
i got old one?

YH
