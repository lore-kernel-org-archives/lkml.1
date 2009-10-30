Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZJ3UpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZJ3UpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 16:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbZJ3UpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 16:45:05 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41940 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbZJ3UpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 16:45:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xre1AMg0ekrdgmPixybWjXyS7ybyolKbF1352G+LqVzQ5DeLCYj4Prbw1Hgt6lp784
         pfKXhDvvDkUSwg8b+Bl/xz8D4Ab+YIV8I94XsOx/JQ+w8IBisexPoZVOYR4UwnYUdnQB
         pmGxCgJ8wgp1hHaP7qFgCcDKYOOCdcvpkjhGg=
Date: Fri, 30 Oct 2009 21:44:27 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Message-ID: <20091030204427.GA2962@ami.dom.local>
References: <1256886023.3555.5.camel@johannes.local>
 <20091030110616.GB6150@ff.dom.local>
 <20091030150223.GA2586@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030150223.GA2586@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 11:02:24AM -0400, John W. Linville wrote:
> On Fri, Oct 30, 2009 at 11:06:16AM +0000, Jarek Poplawski wrote:
> 
> > There are various ways to disagree, and ignoring by John questions
> > from a merited developer both in this referenced lkml and current
> > threads looks at least strange (if not offensive) as well.
> 
> Did you read the thread for which Bartlomiej provided a link earlier?
> There were ten responses (only three of them from him) in that thread.
> His comments were not ignored, they were rejected.
> 
> Ever since Bartlomiej decided to tear himself away from
> drivers/staging, he has been nothing but negative -- petty, whining,
> indignat, whatever.  Just what has he done to merit any special
> consideration here?  Why should he have any sort of veto over rt2x00?
> 
> And of all things on which to take a stand -- how dare the rt2x00 guys
> use two header files instead of three?  The nerve of those people!!!
> 
> Ridiculous...

Maybe. Different tastes for sure, so simply no good solution.

Anyway, my point was somewhere else: Davem could be a good example;-)
I simply can't imagine a thread with such concerns left completely
uncommented before merging a patch. It's not about convincing anybody.
Usually you know at least if the concern is dismissed, or valid, but
fixable. (Sometimes you can even read between lines, or explicit, what
he really thinks...)

This discussion is mainly around trying to omit a maintainer with
"higher authority". Of course it's a mortal sin! ...Except, when the
maintainer doesn't seem to respond at all.

BTW, it seems Bartlomiej's main argument in the current thread has
changed to the non-working driver, so ridiculous only if you have a
clue.

Jarek P.
