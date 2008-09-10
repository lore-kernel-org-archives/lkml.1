Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYIJGWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYIJGWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYIJGWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:22:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:47137 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYIJGWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ND/uwsdjPyE+6T/wTNHCnFxqEoSoL8swpzBZmsVQRMBZWNtYQH1r/xYe5LU0uIUvAT
         4aNNmPSlfWbO2OSArA7I/LXU+jq00WyTYrR5sojSPim86ycz1ENKZhopTYroY8l5B+1K
         MflOBCp/BIs8fvYOxPrusWd53Fv+gxbHl8Y/E=
Message-ID: <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
Date: Tue, 9 Sep 2008 23:22:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
	 <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
	 <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 11:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> ...
>>
>> hope we can keep using MACRO..
>>
>> YH
>>
>
> Btw, Yinghai, what does it mean? To not touch this macro at all?
> Or you mean about implementation issue (ie the design itself)?

do not touch this macro... and may revisit after 2.6.28

YH
