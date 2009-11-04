Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZKDPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZKDPaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZKDPaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:30:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65095 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZKDPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h4w8lyYBQJk3JlfGPr8YXxTT8wZtd9RyWA60V1vESvcYFCLu6Cdtc86FGBIeTQvg/u
         sjnoLQ81PxVg66so9bwcNXzfTCwqDUwKPiiS8A/ivbkDWyHgL6LmNNQVWRxR8/VmrFcA
         CRa+Nj54DqIubrL6Jbw8GuqajIqRsdiT5HA8Y=
Message-ID: <4AF1A198.1090709@gmail.com>
Date: Wed, 04 Nov 2009 15:45:28 +0000
From: Dave Korn <dave.korn.cygwin@googlemail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Dave Korn <dave.korn.cygwin@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0,  oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com> <20091103222432.4a94bd8f.akpm@linux-foundation.org> <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>
In-Reply-To: <4AF198E1.9010303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:

> I can try, only issue I have is I don't
> use a distro, so building anything requires me
> to hand compile it

  Oh, ouch!

> (hopefully not difficult for gdb).

  Indeed, hopefully not.

> So give me some time on this and I'll see if I can get this up
> and running, and add that patch to kernel then go from there.

  The one thing you can still try straight away for minimal effort is the
-fmem-report option, but it's also the least informative...

    cheers,
      DaveK

