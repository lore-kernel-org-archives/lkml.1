Return-Path: <linux-kernel-owner+w=401wt.eu-S1161242AbXBABje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242AbXBABje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 20:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161237AbXBABje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 20:39:34 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:33768 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161234AbXBABjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 20:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WeQZuoV6jVcS2t7ZFMgaHNdqaSwiqHW70iL4JnclAshzgu/lzq/ma/Bdf/mdW8QwUEObsVVeKumV9/Wv66l9hxq4b031v82U4zqNf6LIaECYoKE4HBYVEYmqMjx1imoltxppAabagzKZpt6biW+SCPGBujQI99o63QrJFFItQ6c=
Message-ID: <75b66ecd0701311739y5b9ebf52h296a9435a769bf1d@mail.gmail.com>
Date: Wed, 31 Jan 2007 20:39:32 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Free Linux Driver Development!
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Theodore Tso" <tytso@mit.edu>,
       "Greg KH" <greg@kroah.com>,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45C13DAB.5090305@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	 <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
	 <20070131150451.070fa90f.randy.dunlap@oracle.com>
	 <45C13DAB.5090305@rtr.ca>
X-Google-Sender-Auth: 6ea430214f0fb4c5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Mark Lord <lkml@rtr.ca> wrote:
> Randy Dunlap wrote:
> > On Wed, 31 Jan 2007 18:00:15 -0500 Theodore Tso wrote:
> ..
> >> More specifically, Dave said that it "seemed rude" to just take the
> >> driver and send updates, but maybe the best way of dealing with
> >> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
> >> kind of spec release, and just have someone in the community forcibly
> >> take the code, fix it up, and then get it merged.  Maybe it's being
> >> "rude", but so is not responding to requests to get it merged.
>
> I believe a BIG reason why lots of open-source drivers are out-of-tree
> right now, is because lkml is perceived as being wayyyyyy too fussy
> and petty about 80-column lines, brackets, etc.. for new code.
>
> It's just not worth the effort/abuse for many maintainers to pursue it.

That seems like the easy part - it seems like anyone bright enough to
write a working Linux driver would be good enough with their editor or
perl or bash to knock that out in 10 minutes.

I would think rules like "no new ioctls" and "no new /proc entries",
that might seem arbitrary to one who doesn't follow kernel
development, plus the occasionally insulting code reviewer, would be
more of an issue.

Lee
