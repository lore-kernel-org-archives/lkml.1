Return-Path: <linux-kernel-owner+w=401wt.eu-S1764802AbZDCKk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764802AbZDCKk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764074AbZDCKi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:38:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44029 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763410AbZDCKi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xWH/fQezvy9szvRTzgv7pBuLSZE0Mqi17lNs5waKBZlc9keQovKNw/mFrQllFOED2H
         OOflxEB5Wipu/1TteT15n8dAD/KzD/HtqehzuHzxH9jbc3IPEEmFYqYhW+HSwiCUzaZC
         63vHmxLVIbz8y04ZVelhit52tURxAynrg3wC4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904031226500.12916@localhost.localdomain>
References: <3efb10970904030248t39a13176led25b9dc7ff9383c@mail.gmail.com>
	 <alpine.LFD.2.00.0904031226500.12916@localhost.localdomain>
Date: Fri, 3 Apr 2009 12:38:23 +0200
X-Google-Sender-Auth: 3aafd4832e73319d
Message-ID: <3efb10970904030338h6ff7256ehf6ecd8032f9933d7@mail.gmail.com>
Subject: Re: System deadlock on 2.6.24-rt20
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

>> Does anybody recognise these backtraces? And if so, is there a fix for
>> it already?
>
> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24.7-rt27.bz2

Thanks, for the quick response.
I was already starting integrating -rt27, but I could not predict if
that would solve this problem.
I am happy you confirmed that.

Thanks!

Kind Regards,

Remy
