Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968176Ab0B0KU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:20:59 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:39579 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927Ab0B0KU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M63tfyHtriu+4ja5U6OXpCdY0OAxmsmgoIFAz9u6bIw1+iB0hgHRPtmhVbpLkXFV51
         xpbgVk0qvheDFN2zYZPaV/ZoRclAySRyiN2sGAbUvUR01oISXnSau6SxAiIWWCZEaaoB
         qXe3rclM0S739U/9ern6eMBalV+sQ7/AlxvQ0=
Date: Sat, 27 Feb 2010 11:20:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/07] kernel.h string cleanup
Message-ID: <20100227102051.GD5130@nowhere>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2> <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com> <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 09:15:39AM +0200, Alexey Dobriyan wrote:
> On Fri, Feb 26, 2010 at 3:14 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Yeah, same question, then where should they go?
> 
> Should I hand a patch to you, so you can repost it?
> 
> > I think string.h is fine.
> 
> It obviously isn't fine.
> 
> Why all of sudden kernel.h split when kernel.h is for simple misc stuff
> for which there is no other place.


kernel.h can be split up, just to ventilate it a bit. It's really a
big header so this could be an occasion to organize it a bit.

