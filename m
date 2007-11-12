Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXKLXIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXKLXIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbXKLXIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:08:38 -0500
Received: from mx1.suse.de ([195.135.220.2]:45327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbXKLXIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:08:37 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
Date: Tue, 13 Nov 2007 00:08:34 +0100
User-Agent: KMail/1.9.6
Cc: gorcunov@gmail.com, tglx@linutronix.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <200711122201.45269.ak@suse.de> <200711122355.55314.ak@suse.de> <20071112.145921.193112020.davem@davemloft.net>
In-Reply-To: <20071112.145921.193112020.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711130008.34311.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 23:59:21 David Miller wrote:
> From: Andi Kleen <ak@suse.de>
> Date: Mon, 12 Nov 2007 23:55:54 +0100
> 
> > Sure, it's likely not your time that will be wasted.
> 
> I have to respin in excess of 800 networking patches at a time due to
> these kinds of things.  It's absolutely trivial, whether by hand
> or using tool options that help you with this kind of task.

Sure, but what benefit did it have?

Could you have done something more useful in the time you needed to 
write the scripts for that?

Also it's not only my time -- there are a lot of people who have x86
patches. e.g. if 20 people have patches and they need half an hour
each to write and test and apply scripts for that we're talking about more 
than a man-day overall wasted.

> Suck it up Andi.

Well it just seems a dumb thing to do and I like to complain about dumb things.
Sorry that you are more generous about wasting other people's time.

The end white space tends to disappear over time anyways because
it is filtered out on everything new, but bulk changing it on old
unchanged code is not a good idea.

-Andi (who will shut up because he's approaching the half hour limit
for such silly topics. At least it was only me and you though, not 20 people) 
