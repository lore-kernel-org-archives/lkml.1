Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbXG3WtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbXG3WtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXG3WtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:49:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:54247 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXG3WtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fb8fQhsqrkIxW+lVsjdoVhLAxaoGUBFftzEFxpMq7/OqJhSkgm0rz/6tbXeAEj4uzKeq6Ft+NNPSXCh9yU8q7jS+BArjRwahNVb0fhmeXRum4G9+nDnrrNrb8W6PWcWKOlXGY7TwNKcFnscn1e05+d7/t6hfbUlTSS9QCGA3FX4=
Message-ID: <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
Date: Tue, 31 Jul 2007 00:49:09 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: teresa@kvitka.net
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
Cc: "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1185827130.26459.16.camel@xtower.fri>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185827130.26459.16.camel@xtower.fri>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30/07/07, <::.. Teresa_II ..::> <teresa@kvitka.net> wrote:
> Hi all,
>
>
> first of all i am not sure if its scheduler issue. But i didn't found
> anything about that in google related to something else.
>
> So i tried 2.6.22.1 kernel with new cfs scheduler v19.1 from Ingo page.
> Previous i used 2.6.22-ck1.
>
> After 24 hours running i get strange behavior in Xorg. It act slower
> with my special keys, like SHIFT, or CTRL. So if i hold SHIFT and press
> ")" and than will press enter, i release SHIIFT and press ENTER it
> doesn't create new line. Even if i start write a Sentence or word with
> "SHIFTed" char it makes next char in high case also.
> Like this: "HAllo" even if i type "Hallo".
>
> It's extremely unusable.
>
> It doesn't happen if i am on other kernel.
>
> I am ready to provide any requested information to find issue.
> If its not kernel related thing - i am very sorry, i just don't know
> where to start to trace whats wrong.
>
> I am on gentoo and use latest xorg server. Keyboard driver is "KBD".
> Mouse use "evdev" driver.

Ingo, can you take a look at this?

>
> --
> Teresa Kalitowska
> jid: teresa@kvitka.net

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
