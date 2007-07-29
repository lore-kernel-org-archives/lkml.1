Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXG2XFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXG2XFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764015AbXG2XFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:05:00 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:48262 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXG2XE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CkXWwer3TPKNboyV3BKg+mUDFiu4yhEp0JsqmyLqPT9qpjDah+0VGr51FPe6UluD6jSa+uavWqbv8q0KzxXplegpL+4xrZG25riI8AMWEBW2RZHn10RcM7VgMr2HFjclURtXbhk2BoSuEnoJ21NuC4CVeOWOcA0isPDe3jj7yKw=
Message-ID: <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
Date: Mon, 30 Jul 2007 09:04:58 +1000
From: "George Sescher" <gesacs@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linus 2.6.23-rc1
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "CK Mailinglist" <ck@vds.kolivas.org>
In-Reply-To: <20070729150436.GA6598@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * Kasper Sandberg <lkml@metanurb.dk> wrote:
> > [...] As far as im concerned, i may be forced to unofficially maintain
> > SD for my own systems(allthough lots in the gaming community is bound
> > to be interrested, as it does make games lots better)

On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> i'd encourage you to do it - in fact i already tried to prod Peter
> Williams into doing exactly that ;) The more reality checks a scheduler
> has, the better. [ Btw., after the obvious initial merging trouble it
> should be much easier to keep SD maintained against future upstream
> kernels due to the policy modularity that CFS introduces. (and which
> policy-modularity should also help reduce the size and complexity of the
> SD patch.) ]

<chuckle>

You're advocating plugsched now?
