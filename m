Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbXA3WV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbXA3WV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXA3WV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:21:57 -0500
Received: from hu-out-0506.google.com ([72.14.214.230]:17204 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbXA3WV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YMhnj0XY1fC+4sRIyI+CzlscwRT/ips7tPlEurJdEQyzbyTZvV9uyTazJxyNQouLNJPeCld6FIpEH8V5ZlR9fD+KCI2zqe8Y7mzRbvz3mfORxX2XPChOZeyC2FGbaaaHWuuRAHYz01gBr79exfsPhYrI6X1ESSkASN61Ca+rdVE=
Message-ID: <1a297b360701301421t7472771fxfd93db5ae80d4839@mail.gmail.com>
Date: Wed, 31 Jan 2007 02:21:53 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Free Linux Driver Development!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070130191117.GG20642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com>
	 <1a297b360701300930m90a09bbp30bed58c9c9bf456@mail.gmail.com>
	 <20070130191117.GG20642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 30, 2007 at 09:30:23PM +0400, Manu Abraham wrote:
> >
> > Sounds very nice indeed. Just happened to do a driver in a similar
> > status, where the vendor did not want to make the specs and other
> > stuff open, but was in a position to support an OSS driver for the
> > STB0899 demodulator driver from ST Microelectronics
> >
> > I think many vendors will be ready to jump in.
>
> Based on the initial response so far, a number of them seem very
> willing.
>
> > the STB0899 demodulator driver is now available at
> >
> > http://linuxtv.org/hg/~manu/stb0899-c5
> >
> > It needs some fixes with regards to our DVB API. (bumping it up to 3.2
> > from 3.1) It's almost ready to rock now, with new delivery systems.
>
> Glad to see that we are getting more device support :)
>

Not only that, we will be adding in even more delivery systems like
DVB-S2, DVB-H, DSS and other than that, we will be having algorithm
based tuning rather than dumb tuning.


regards,
manu
