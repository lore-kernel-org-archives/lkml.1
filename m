Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbZFNNQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbZFNNQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZFNNQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:16:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:40533 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbZFNNQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DBD1scJ7n5/hab8CBOWI9ZaOjxKcp1BU7x8FFI67nwJgFet7H7RIZoCgYjRm6mO4Wx
         jpOHRjJTBSz9X4yfMjytd40PlD1jIJWUY/8M5bnL4Ti3XV6nyVcfjfzTCDhYuskMrl3J
         TsQBUHLhdQ0m2Wg25GMtdwykzRed22ed/kxBI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0906101333350.3351@localhost.localdomain>
References: <b9df5fa10905251820l3783327ek4f6b7014aa167690@mail.gmail.com>
	 <86802c440905251911h6f6c146eo4c30d306ac8d17d8@mail.gmail.com>
	 <b9df5fa10905261949j3eb4dc9ft321dba3c46c335db@mail.gmail.com>
	 <b9df5fa10906100424h98862a8l32951906d06454fb@mail.gmail.com>
	 <alpine.LFD.2.00.0906101333350.3351@localhost.localdomain>
Date: Sun, 14 Jun 2009 19:16:27 +0600
Message-ID: <b9df5fa10906140616y38c74425vcccc639fc288e305@mail.gmail.com>
Subject: Re: [PATCH] v2: x86,APIC: Detect lapic_is_integrated() once - use on 
	and on
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, yhlu.kernel@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, macro@linux-mips.org,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 5:34 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> On Wed, 10 Jun 2009, Rakib Mullick wrote:
>
>> Hi Ingo, Thomas and everyone, would you please take a look at this
>> patch and comment ? I think Thomas was agreed with this one. Is there
>> anything that i couldn't deliver? If i'm wrong please notice thus i
>> can fix myself.
>
> The patch is fine, but it lacks a proper patch description.
>
> Thanks,
>
Thanks Thomas. I understatnd my problem. I'm resending the patch with
proper patch description.

Thanks
>        tglx
>
