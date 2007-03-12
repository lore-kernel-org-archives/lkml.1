Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXCLG60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXCLG60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 02:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965238AbXCLG60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 02:58:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:19857 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbXCLG60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 02:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e7u6rEmmmRZESNBB2FR8pFVBrpvepevvkALsqabmUkWMFmPZBBON85X49p+OvArG4AMT+TPbv+H4L9vIkooKoTWbhXOd/sX3tCTtIszvjI2ly9+h5/ShqVt2XiNkuCFJ8Dmgd7vv7MzHZjNlAIiOPNOA6YU0dIZ36z5RjVp/cQU=
Message-ID: <f44c5fdf0703112358j4f94998aq9e45b0a6e848551d@mail.gmail.com>
Date: Mon, 12 Mar 2007 07:58:24 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Cc: linux-kernel@vger.kernel.org, "Mike Galbraith" <efault@gmx.de>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200703111032.40296.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
	 <1173613149.6927.29.camel@Homer.simpson.net>
	 <200703111032.40296.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Sunday 11 March 2007, Mike Galbraith wrote:
>
> Just to comment, I've been running one of the patches between 20-ck1 and
> this latest one, which is building as I type, but I also run gkrellm
> here, version 2.2.9.
>
> Since I have been running this middle of this series patch, something is
> killing gkrellm about once a day, and there is nothing in the logs to
> indicate a problem.  I see a blink out of the corner of my eye, and its
> gone.  And it always starts right back up from a kmenu click.
>
> No idea if anyone else is experiencing this or not.
>
> --
> Cheers, Gene

I've had such an issue with 0.20 or something. Sometimes, the
xfce4-panel would disappear (die) when I displayed its menu.
Very rare issue.

Doesn't happen with 0.28 anyway. :-) Which looks really good, though
I'll update to 0.30.
