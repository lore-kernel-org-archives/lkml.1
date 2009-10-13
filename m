Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZJMIqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZJMIqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbZJMIql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:46:41 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:32785 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbZJMIqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OI70WRKOMUpE+LfKPOC8MSc53AaE2avg80wGKKsUwPNKft8kn9//sRN/voqKcOV4hz
         jv+MDbeplxfq3/67sJYuuX7I4F3KaeCO0YcKmCT0YOuz3GVVnB99N2vHAuveiYbiNBuZ
         uGTtqZAuTdptOaVFZz+dsjlajTUIuBOvrJlIk=
MIME-Version: 1.0
In-Reply-To: <200910122323.29475.rjw@sisk.pl>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	 <L6tb-VyKHZK.A.n4E.T1l0KB@chimera>
	 <b637ec0b0910120024h463c78e5l67f646f262e0c13c@mail.gmail.com>
	 <200910122323.29475.rjw@sisk.pl>
Date: Tue, 13 Oct 2009 10:46:04 +0200
Message-ID: <b637ec0b0910130146u32442b7fvd18a7e2d97c4b727@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

On Mon, Oct 12, 2009 at 11:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 12 October 2009, Fabio Comolli wrote:
>> Actually I switched to -32rc so I can't test it anymore... Sorry. I
>> can confirm it for 2.6.31.1.
>
> Does it happen in -32-rc?

Please have a look at my other bug report which applies to 32rc (#14372).
The result is the same (wifi down after resume) but the warning does
not show up.

The "cure" is also the same (rfkill-off followed by rfkill-on).

>
> Rafael
>

Regards,
Fabio
