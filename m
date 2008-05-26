Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYEZIHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYEZIHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYEZIHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:07:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:45239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYEZIHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Abv6mknY8hsAeskqLbw9ZaochNAtxEBaa19Gk2ZyrBiUufhwdy8k01kBPiIdktnnGDVWkpJNJRuzhM3YEEvbr2eWiCGBHRyiE5L5T1Govvl9jAyiek5/Il1zjD1tUb9eeSWBgdKeCjjAH1Rmi07IB/CxDyNC2QSH6MGMfq7Pnhw=
Message-ID: <483A6F94.5070901@gmail.com>
Date: Mon, 26 May 2008 10:06:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: S K <nospamnoham@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem activating multiple cores ONLY if I press any key before
 kernel is loaded
References: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
In-Reply-To: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2008 05:39 AM, S K wrote:
> and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.
[...]
> I see this in dmesg:
> CPU 1 irqstacks, hard=c07ba000 soft=c079a000
> Not responding.
> Inquiring remote APIC #1...
> ... APIC #1 ID: failed
> ... APIC #1 VERSION: failed
> ... APIC #1 SPIV: failed
> CPU #1 not responding - cannot use it.
> Booting processor 1/2 ip 4000
> Not responding.
> Inquiring remote APIC #2...
> ... APIC #2 ID: failed
> ... APIC #2 VERSION: failed
> ... APIC #2 SPIV: failed
> CPU #2 not responding - cannot use it.
> Booting processor 1/3 ip 4000
> Not responding.
> Inquiring remote APIC #3...
> ... APIC #3 ID: failed
> ... APIC #3 VERSION: failed
> ... APIC #3 SPIV: failed
> CPU #3 not responding - cannot use it.
> Total of 1 processors activated (5015.39 BogoMIPS).
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> Brought up 1 CPUs

Does it work with vanilla? If yes, contact your kernel provider (redhat bugzilla).
