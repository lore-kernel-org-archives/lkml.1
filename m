Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYD0JQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYD0JQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYD0JQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 05:16:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:44703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYD0JQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 05:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B34E0FGOdQo0q4jWpcKgMoXRqycjHV59aZ+KuIhQHD5QT28SO72gol63HNdIKnEGWRCfhf1TYznPx2YUGDa8A1WcOiRP8KjDUId9AjmD6wDiiHK4BlHU1FBHtAyq2MgBKM7gIVLaJ0IIIJjZf+8vE7akA+5lcQLaPOmwy60/K2A=
Message-ID: <21d7e9970804270216rcaf2462v4ee6f34cf9f9aa45@mail.gmail.com>
Date: Sun, 27 Apr 2008 19:16:31 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "SL Baur" <steve@xemacs.org>
Subject: Re: CONFIG_OPTIMIZE_INLINING
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
In-Reply-To: <ed10ee420804270210y219ac4dbne858906233ab9691@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426.215513.141243565.davem@davemloft.net>
	 <20080427055943.GA16290@elte.hu>
	 <20080426.230807.144232984.davem@davemloft.net>
	 <ed10ee420804270210y219ac4dbne858906233ab9691@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 7:10 PM, SL Baur <steve@xemacs.org> wrote:
> On 4/26/08, David Miller <davem@davemloft.net> wrote:
>
>  >  Because anyone who is paying attention can see clearly that you're
>  >  trying to push as much stuff as quickly as possible into Linus's tree
>
>  I'm giving up for the moment trying to review anything.  I can't contribute
>  by compile testing a lot of stuff - I don't have a farm of computers that can
>  build and boot thousands of kernels overnight, nor a machine that can build
>  a kernel in 2 minutes, nor a suite of cross-compilers that can test
>  build patches
>  across all the architectures we support.  I'm not paid to follow any of this, my
>  only paid concern is Linux userland and so following Linux Kernel is a hobby.
>
>  If you, Ingo, are going to push patches in before they can be reviewed, what
>  reason is there for anyone to bother trying?  (The patch I was trying to review
>  that you merged before review was complete was different than this one).
>
>  Oh and Thank You! David for starting to post your git pull messages.  Idiots
>  like me read those sorts of things and appreciate it *very* much.
>
>  -sb  (I *like* reading patches and I want to contribute any way I can)
>

The thing is merging doesn't change the code, reviewing patches in
Linus' tree or patches on there way to Linus' tree,
shouldn't really affect review unless its in the creating a new
userspace API area.

so please continue to review the patches even if they make it
upstream, you can still provide feedback,

just because something lands in the core kernel tree doesn't mean it
is actually perfect, far from it..

Dave.
