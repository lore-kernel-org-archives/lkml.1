Return-Path: <linux-kernel-owner+w=401wt.eu-S1031656AbXHMQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031656AbXHMQzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948405AbXHMQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:28:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:16192 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S948398AbXHMQ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aCi0mQRfU3tRymK/0ViyDGqkDjiDFEpBPvhFB2sSncAmBo1X74fMujCiqulHPmIT4A9Oh7CGAc/RE1Gepht1cslj2ooax1cEpWNhTshYyFnXAzwUsuyC/Cl4j9J21oinE9U1tQZUzjIqQBZG2cOToARKNFZQ3xmk7p56qacSzzA=
Message-ID: <6bffcb0e0708130928k726bd676p79c18549dc814d05@mail.gmail.com>
Date: Mon, 13 Aug 2007 18:28:09 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Chris Holvenstot" <cholvenstot@comcast.net>
Subject: Re: Kernel 2.6.23-rc2 git4 & git5
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1186954962.8166.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186954962.8166.19.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 12/08/07, Chris Holvenstot <cholvenstot@comcast.net> wrote:
> This morning I reported an issue which cause a failure of the
> 2.6.23-rc2-git4 kernel to boot on my system.  The contents of my post
> may be viewed here:
>
> http://www.ussg.iu.edu/hypermail/linux/kernel/0708.1/1959.html
>
> After 3 separate builds from "virgin sources" I still had the boot
> failure with the git4 level kernel.
>
> This afternoon I picked up the git5 patch and it comes up and appears to
> run without problem.

Great!

Next time, please reply to original report. It is much easier to track bugs.

>
> Same base system.  Same hardware.  Same build process.
>
> So even though I have only been building and running "pre-release"
> kernels for a short time I feel confident in saying that something was
> not kosher with the git4 patch - at least when it came to my system.
>
> (system configuration data is in the original post)
>
> I would not normally burn the valuable time of others with a rhetorical
> post but I looked at the changes out into the git5 patch and did not
> spot anything that looked like it would have resolved the issue I was
> having and I hate not being  able to correlate a cause and effect here.
>
> Any clues, or did I just get lucky with this one?
>

I guess the problem is fixed.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
