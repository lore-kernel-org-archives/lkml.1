Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYIQTGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYIQTGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYIQTFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:05:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:7687 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbYIQTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QF6s69IRfr+l8dBHhbP5PiGlYGkk8R44cj0ZWEEKdgTMBygLBSaGX+tKMkEMZho7NJ
         qcMlivPykQ1oCVv8wWcP2aywWEBNqkBcCnkvc8JpuWxcc5Dja2XwCOPFTfsKuS87nt8d
         pXO0dZeHSmvPV2bnD3Q+ZgHtHXf2MYjLVv/cU=
Message-ID: <86802c440809171205u67181abfi3e0043e0b5eaef6@mail.gmail.com>
Date: Wed, 17 Sep 2008 12:05:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48D149CA.1000000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080917073058.GA3770@x200.localdomain>
	 <20080917084754.GC24035@elte.hu> <48D13960.2020902@zytor.com>
	 <86802c440809171110y3b91e27q382c6ee7bcd58c28@mail.gmail.com>
	 <48D149CA.1000000@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>>>
>>> It's probably worth pointing out that we had similar transition pains
>>> when
>>> we introduced the loglevel tags.  If you used an old dmesg/klogd you got
>>> the
>>> loglevel tags; we cleaned them up.
>>
>> want to expand loglevel tags to two digi bits, hope the dmesg/klogd
>> could handle it.
>>
>
> I doubt they'd be written to handle that already.
>

dmesg util in opensuse 10.3 does support two digi bits loglevel tags.

YH
