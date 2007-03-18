Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXCRPod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXCRPod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 11:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXCRPod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 11:44:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:24307 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbXCRPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 11:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UxyTgT9Ku+zcnH+Nmyj4slbbBAD4/ZlkIsCHmuzl1efzWccRsnfXPWvrHGz2r5XRUVSiqKqmDiBuk8eCSEz8jgP1gQzmKlJVkPETXqDvM8+g/ee5tAhAmplQaN2T8UE8PRPUv790TNzzA1yPhDFl7a8e1FW/ntrsLyYvu7nb9fQ=
Message-ID: <f44c5fdf0703180844w33f4ae20gcccdccf6a7ba3e03@mail.gmail.com>
Date: Sun, 18 Mar 2007 16:44:31 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ck] Re: RSDL v0.31
Cc: "Kasper Sandberg" <lkml@metanurb.dk>, "Al Boldi" <a1426z@gawab.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nicholas Miell" <nmiell@comcast.net>
In-Reply-To: <1174203482.8855.8.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
	 <1174200463.10498.23.camel@localhost>
	 <1174201726.8732.6.camel@Homer.simpson.net>
	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>
	 <1174203482.8855.8.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/07, Mike Galbraith <efault@gmx.de> wrote:
> Hm.  Sounds rather a lot like the...
> X sucks, fix X and RSDL will rock your world.  RSDL is perfect.
> ...that I've been getting.

Blah. Nothing's perfect. Especially not computer programs.

Still, it's not a smart decision on KDE's part.
It will break a lot of scheduling decisions, esp. you can't use IO priorities.
