Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZJ2TpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZJ2TpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZJ2TpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:45:05 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49928 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZJ2TpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=c92nnml2ZqvejFpGr9EZi1AqeX6k1DZqyMlv7gLbYneBi8Pgbsq0RyZv7IHQQUU0cC
         sYLLQG272RVurRd404pEJ47izl7EbYxNK5skMOm4TvwM0A/IPXxsjAV4lZtoM+EmnB+G
         eFYJ4dyPbmdLnY04kaDJBOY4l/RCe3qb2reQ0=
MIME-Version: 1.0
In-Reply-To: <200910291514.40318.bzolnier@gmail.com>
References: <200910291212.41656.bzolnier@gmail.com>
	 <200910291435.54203.bzolnier@gmail.com>
	 <84144f020910290652n2e75827dk698b238b6bd1cbed@mail.gmail.com>
	 <200910291514.40318.bzolnier@gmail.com>
Date: Thu, 29 Oct 2009 21:45:07 +0200
X-Google-Sender-Auth: 2687e2672f206d38
Message-ID: <84144f020910291245l1a7a3fd6o8822ecd4ce3b5504@mail.gmail.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Thu, Oct 29, 2009 at 4:14 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>> lots of cleanups to the staging drivers, why not direct some of that
>> energy to the drivers/net/wireless ones?
>
> When did we start to apply "fix it yourself" rule instead of "submitter
> should fix it" one to the _new_ code..

Don't be silly, I didn't say that.

I was simply pointing out that your time would probably be better
spent in improving the "proper" ralink wireless drivers but if you
_really_ prefer to spend your time in pointless arguments, go ahead.
It should be pretty obvious by now that the best way to improve things
is to work with the relevant maintainers, not against them. (Unless
you wish your work to be ignored, of course.)

                        Pekka
