Return-Path: <linux-kernel-owner+w=401wt.eu-S1765587AbZFOUQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587AbZFOUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZFOUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:16:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:61091 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZFOUQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c4MzzPrX+XAH2+m6RjiN4MEFfdTD03AoxlMBCBjCyYSaWq8lfhbnsycXvnXju9ectY
         AbwLWw0xhPOsd3oU9KXNKbp2l/OFTo7/NIIQcIKswjUXnxYAioHvBabaSbhw8HkTRYiG
         BhVPPiTixtvm9EUChnleTnma8WyKaMfJNCwr8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain>
Date: Mon, 15 Jun 2009 13:16:20 -0700
X-Google-Sender-Auth: 494ca70a2b229124
Message-ID: <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
Subject: Re: [GIT pull] ntp updates for 2.6.31
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Miroslav Lichvar <mlichvar@redhat.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 7:06 AM, Thomas Gleixner<tglx@linutronix.de> wrote:
> Linus,
>
> Please pull the latest timers-for-linus-ntp git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-ntp
>
> Thanks,
>
>        tglx
>
> ------------------>
> John Stultz (2):
>      ntp: adjust SHIFT_PLL to improve NTP convergence
>      ntp: fix comment typos

Thomas,
   Could we hold off on pushing this? I'm still working with Miroslav
to try to work out a solution here from ntpd user-side.

thanks
-john
