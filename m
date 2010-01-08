Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594Ab0AHBoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0AHBoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218Ab0AHBob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:44:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:40917 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0AHBoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rcbVtRDX2DsM6jomSpcitZ+m+I0mT5aViVU07Kg495AC23JsL+WhQ1Zqafay/5OW2+
         JvOE7UW8ncRW87grW37mjNNv/gDuX926IHhZsJq7jXpJjhwKFuP86uWjW2ATj3xG/p6C
         uu+aSpvO0zWb0AW4xsGQXNMAfhgTc/ld8y2OY=
MIME-Version: 1.0
In-Reply-To: <1262903483.5722.7.camel@utx.utx.cz>
References: <20100107203104.GA22681@elf.ucw.cz> <1262903483.5722.7.camel@utx.utx.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 8 Jan 2010 09:44:10 +0800
Message-ID: <f17812d71001071744m2dccc09btf0ea2a63ccd33b55@mail.gmail.com>
Subject: Re: [patch] fix strange characters in zaurus gpio .desc
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/8 Stanislav Brabec <utx@penguin.cz>:
> Pavel Machek wrote:
>> From: Cyril Hrubis <metan@ucw.cz>
>>
>> Somehow,
> Some = my Evolution Mail
>
> I remember that I prepared a patch and fixed capitalization of these
> strings in the mail body in the last minute before sending.
>
>> strange characters made their way zaurus gpio .desc
>> fields. Fix it.
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> Acked-by: Stanislav Brabec <utx@penguin.cz>
>

Applied.

> Hint: If you use Evolution Mail for sending mails, never edit anything
> inside inlined patch and never use old mail as a template, otherwise
> Evolution Mail will include invisible characters to your mail.
>
> Let's see whether it is fixed in the evolution-2.28.
>

Documentation/email-clients.txt may help?
