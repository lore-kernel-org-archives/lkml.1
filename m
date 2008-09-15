Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYIORSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYIORSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYIORSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:18:16 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:65473 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYIORSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R0w/Qhd7n1eqloVZLZFY7DWwshjHuxEwdH585RI5f7xKlQYHTCb4r7wJzW/4gvjPGV
         mB16Dt2AmbvVv/2VGNRqzLra/c1V73KouCBHrUpB2HKjMyK6WTnTMdWJk2PAEcudkcyl
         xq77OrCbiDlgoVGSm14zobx5p/7IkYcLTlGBI=
Message-ID: <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
Date: Mon, 15 Sep 2008 10:18:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48CE983C.8040709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <48CE983C.8040709@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 10:15 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> could be enabled via "boot=verbose" to get more debug info
>>
>> will use it to convert some printk(KERN_DEBUG ...)
>
> This seems odd, why not just use KERN_DEBUG?
>

some guys complained that it is even too verbose with KERN_DEBUG

YH
