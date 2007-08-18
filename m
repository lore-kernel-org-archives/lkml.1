Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbXHRKWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbXHRKWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbXHRKWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:22:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:31767 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbXHRKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uebvSKJrDzXD5uFOVWfuYolLrnCaum1VdNS7bIfzqDSE3wUgPRLzLXjKLZqOHW3ZGA8ZunJL3/8OjtuhmKEN9Dk7fmds7HzViZSb8hneFDVnPz8lPSMvKJ1qciRd33bNCqKysbBnJCXdeKw48d5vng3jt7PjN4mbJ0TVT3GkkSk=
Message-ID: <ab40e9c0708180322p3e8fa27bh77cfbb8195548758@mail.gmail.com>
Date: Sat, 18 Aug 2007 12:22:29 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: kernel 2.6.19 porting
Cc: "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <46C6C2D5.205@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708170924h5b958423jcd0e82e211ca8463@mail.gmail.com>
	 <20070818052805.GO6002@1wt.eu> <46C6C2D5.205@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I will try that.

thanks :)

2007/8/18, Stefan Richter <stefanr@s5r6.in-berlin.de>:
> Willy Tarreau wrote:
> > On Fri, Aug 17, 2007 at 06:24:17PM +0200, Xu Yang wrote:
> >> I have built up a software virtual prototype system with ARM11MPCORE.
> >> my system is similar with realview_eb_mpcore. but my system is
> >> simpler, which has only a mpcore , uart0, console,timer0_1, and
> >> memorys.
> >>
> >> I want to run kernel 2.6.19 on it.
> ...
> > If you upgrade to a more recent kernel (eg: 2.6.22), you'll get
> > more feedback because it's fresher in people's mind.
>
> Also, newer kernels apparently have updates which are relevant to EB MPCore.
> --
> Stefan Richter
> -=====-=-=== =--- =--=-
> http://arcgraph.de/sr/
>
