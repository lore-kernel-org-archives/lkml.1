Return-Path: <linux-kernel-owner+w=401wt.eu-S1422905AbXCBG7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422905AbXCBG7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422976AbXCBG7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:59:35 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:56513 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422905AbXCBG7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pwiJkEUEv2kTsDcDNxkMWaWMyKFlcDTA+S4li+DloIOh2FCSa9ntp1Jocwr/kvTKqXWrYQh0VbgD6th5q/nXw5HrX09WpQFYq2aQqKB7kgxN16DwPgwOP7lOK+Brz0P0KCSqsBZ3YhCwkmWFhj3OVLRF6e4w3xF+GXgsOVGlPSw=
Message-ID: <8cd998d50703012259l274b2d13k6da5048706c4664a@mail.gmail.com>
Date: Fri, 2 Mar 2007 17:59:33 +1100
From: "Con Kolivas" <kernel@kolivas.org>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: belkin bulldog ups monitor vs 2.6.21-rc2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200703020042.17902.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703020042.17902.gene.heskett@gmail.com>
X-Google-Sender-Auth: 48319cd67cb15b50
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> Greetings;
>
> I just rebooted to 2.6.21-rc2 and noted that getting x up and running was
> about 15 seconds longer than usual.  When it got a bash shell going I
> went to it and ran htop which showed that the bulldog monitor was taking
> 90% of the cpu.  Killed it, then restarted it, but when I ran the gui
> which ran fine and then stopped the gui, the daemon once again went hog
> wild and had to be killed,  and I'm losing my kmail composer focus for 30
> seconds at a time now that amanda is making her nightly run.
>
> There is nothing in the log about it other than from xinetd as it ran the
> amanda server stuff.
>
> Not quite ready for prime time methinks.  Using the ck scheduler, this is
> terrible performance, virtually no multitasking.  Back to 2.6.20-ck1 in
> the morning if it lives the rest of the night.

HI Gene.

I'm not sure if you're saying here that the performance is terrible on
2.6.21-rc2 only with the -ck scheduler, or only 2.6.21-rc2, or that
2.6.20-ck1 is terrible or that it fixes the problem.  Can you please
clarify this?

Regards,
-ck
