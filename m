Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYDLTIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYDLTIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYDLTIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:08:47 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:21847 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754608AbYDLTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TlH3PvRGziF7cJ7oqSA2UrI7VWHgW8Ryk+3HlISdfKXInYnzFOtW8fvlUG/fflPhdcDvEIIig/Lam6HUBDkWhQ+UhZJF6i4ghkSS/gc4puGoQLIhPQ0spjHJMvJi3wb7DhKN5cla3JruqtoYRHW/bM0pX+ZfW4SW8tZl78bM3vc=
Message-ID: <86802c440804121208g1ee18b62y50a075afa66ff7c6@mail.gmail.com>
Date: Sat, 12 Apr 2008 12:08:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Kernel Oops on hot insertion of USB
Cc: "Rachmel, Nir (Nir)" <rachmel@avaya.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080412165919.GA30848@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
	 <20080412042918.GA13154@kroah.com>
	 <11486DD9B957EA488E21C44BC8737EFC55F379@307622ANEX5.global.avaya.com>
	 <20080412165919.GA30848@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 9:59 AM, Greg KH <greg@kroah.com> wrote:
> A: No.
>  Q: Should I include quotations after my reply?
>
>  On Sat, Apr 12, 2008 at 11:20:08AM +0200, Rachmel, Nir (Nir) wrote:
>  > Hi greg,
>  >
>  > Thanks for your reply. I am aware that I am "a bit" far behind in the
>  > Linux revsions tree,
>
>  Just a "bit", if you consider almost 3 years and many hundreds of
>  thousands of changes a "bit" :)
>
>  > however it will be very difficult for me to upgrade.
>
>  Why?  Userspace should work just fine.  If you are relying on custom
>  kernel modules, well, I think you now know the reason the kernel
>  developers are saying for people to get their code upstream to prevent
>  this kind of issue...
>
>  > I have done much work and testing with 2.6.14.7 and would
>  > prefer to patch it over upgrading it to the current version.
>
>  Hopefully you are able to patch all of the bugs and security issues that
>  have been found in the past 3 years.

should be typo. Is there any 2.6.14.7 ?, it could be 2.6.24.7

YH
