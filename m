Return-Path: <linux-kernel-owner+w=401wt.eu-S1422857AbXD3XIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857AbXD3XIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422943AbXD3XIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:08:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:41756 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422857AbXD3XIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SOH91Xg7+x1h+PKuphfq4K7itw4c1gzTs6EAjB1WaBFDVyH8kb6He1y5EG7eYx9CRQsO1ge7Up10ITxapWdkb8IMXGhv6QBtb2uPB5OwslcVQa5JbaInhEB7Rar+8AViFDQ9cttpAmEUtpj5hWQUlyFuVuERnazhzykDvWEepcA=
Message-ID: <d9def9db0704301608sf73fb45q2c381d5d25865a22@mail.gmail.com>
Date: Tue, 1 May 2007 01:08:09 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing list" <linux-kernel@vger.kernel.org>,
       "Linux DVB" <linux-dvb@linuxtv.org>
In-Reply-To: <463674A9.9040100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070429182209.267430@gmx.net>
	 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
	 <20070429205925.129920@gmx.net>
	 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
	 <20070429230037.95120@gmx.net>
	 <alpine.LFD.0.98.0704300854090.9964@woody.linux-foundation.org>
	 <Pine.LNX.4.58.0704301458460.315@shell2.speakeasy.net>
	 <463674A9.9040100@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> Trent Piepho wrote:
>
> > The issue with dst is just a minor missing feature to fully support the
> dvb
> > helper module customization system.  So nobody needs to worry about this
> > anymore, the last two patches in this repository will fix it correctly.
>
> With regards to the dst, i have explained earlier to you that
>
> 1) the dst is not a frontend
> 2) i do not wish to use the frontend attach methods with regards to
> dst/dst_ca
>
> To mention, we had these discussions much long back how to go about it
> and don't think that every time a new developer get's an account with
> linuxtv.org, this has to be a matter that has to discussed to death
>
> http://article.gmane.org/gmane.linux.drivers.dvb/16156/match=patch+dvb+bt8xx+cleanup
>
> (eventhough of not much concern) If you now see most of the code in
> dvb-bt8xx especially the DMA stuff was refactored from the dst driver.
>
> But that said, the dst *is* different, so WTH ?
>

Please show me where this change makes your work more difficult,
Trent's change is small and I don't see the problem where it seriously
affects your work.

Markus
