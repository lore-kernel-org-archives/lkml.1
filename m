Return-Path: <linux-kernel-owner+w=401wt.eu-S1762778AbXHFHA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762778AbXHFHA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXHFHAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:00:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:26605 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXHFHAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WxHGChdS8+Ys0Ya1pHAMEi9Nx/93PSaCACANQbBQA7F0b9pQHhfnvTygaBzNzUZgfV63G23eHElD2TIDSN9gzdYfszmk90pBlEv7uD1J9K5nftym68g8k8fydjaqZpKfvhC/DMUp2bpfPYaDSMA0z4bCti2WC1Xw8LYzSAJ1P2M=
Message-ID: <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com>
Date: Mon, 6 Aug 2007 09:00:44 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070731132037.GC1046@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	 <1185322771.4175.102.camel@chaos>
	 <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
	 <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos>
	 <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local>
	 <20070726091254.GA8063@elte.hu>
	 <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
	 <20070731132037.GC1046@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/31, Jarek Poplawski <jarkao2@o2.pl>:
> Marcin,
>
> I see you're quite busy, but if after testing this next Ingo's patch
> you are alive yet, maybe you could try one more "idea"? No patch this
> time, but if you could try this after adding boot option "noirqdebug"
> (I'd like to be sure it's not about timinig after all).
It didn't change anything. Network card still timed out.

Marcin
