Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbZH0TJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbZH0TJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZH0TJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:09:33 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:41826 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZH0TJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=U6Y1tbGwDREsOGelGD/6HGROLB+YP5AO9cZukPJ9dc6nCVZGeBwMzVOAmSA4aZhd7s
         F0K4VKc0Es3nt7QSSWGe3XnBteBMhc91AgGSLcDg0jxRPFMU39CCbBCLTI0GzKsJOw4S
         NWuMv3ciD9HEiYNPJpK7LKc6kW1eUFVbXudn0=
MIME-Version: 1.0
In-Reply-To: <20090827182952.GC10360@sequoia.sous-sol.org>
References: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com> 
	<20090827182952.GC10360@sequoia.sous-sol.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 12:09:14 -0700
Message-ID: <43e72e890908271209mdbaaf03l820aade2266eb54c@mail.gmail.com>
Subject: Re: Would it help to encourage users to read/test stable-review 
	patches
To: Chris Wright <chrisw@sous-sol.org>
Cc: stable-review@kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       =?UTF-8?Q?Christian_St=C3=B6veken?= <launchpad.net@excogitation.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:29 AM, Chris Wright<chrisw@sous-sol.org> wrote:
> * Luis R. Rodriguez (mcgrof@gmail.com) wrote:

>> Also what if a user just wants to test an entire series queues up
>> for stable-review, is there a single all-in-one file user can just
>> patch -p1 to help test prior to getting the next stable release made?
>
> There is a queue that can be applied w/ quilt  (or any similar tool that
> can handles patches + series file).  This is kept here:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git

For us non-quilters and lazy people can we get an all-in-one patch
generated from a script or something? If not I can just try to keep
one up to date myself but figured since you have a tree it may be
easier to refer the one place instead of two.

>> Do we want more user exposure to stable-review mailing list or is just
>> a few developer eyes enough?
>
> More review never hurts, but do you think there's a specific lack or
> problem?

Not really, I was thinking about the fellow Ubunteros users who tend
to not have a clue but sometimes enough good will to want to help. If
the average user understood better the upstream process then perhaps
it would become clearer to them the importance of stable patches and
stable-review. Bringing users closer to stable-review to me indicates
more users would understand the stable process and therefore would
stop bitching to me when a 'non-cirtical' fix never made it into their
ancient stable. Cc'ing one of those.

  Luis
