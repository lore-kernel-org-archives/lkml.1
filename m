Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbZJFSYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbZJFSYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbZJFSYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:24:32 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45389 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087AbZJFSYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nODnvUU0dLP0B2d5wyHY0hTqATN8Sg1c+Wr047Su2iwcZbWoFu6TBXsMkhp3quKej8
         Ie3rLdi6i8bcXMXm3WQcGXKFUOW1X6v84r8IuQi0E2EcnbcGj82944FnIrK7EGhRQd8w
         OmtYJpIssADWqZfj+xs34RU7VVfkBpWNMifUg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
	 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
Date: Tue, 6 Oct 2009 20:23:53 +0200
X-Google-Sender-Auth: 87198a1e312ab737
Message-ID: <3efb10970910061123k2b6826bci11f0f42509173b26@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31.2-rt13
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2009/10/6 Thomas Gleixner <tglx@linutronix.de>:
> We are pleased to announce the next update to our new preempt-rt
> series.
>
>   - Forward to 2.6.31.2
>   - Futex fix
>   - iptables fix

Great!

But I was wondering if you missed this one:
http://patchwork.kernel.org/patch/50044/

Remy
