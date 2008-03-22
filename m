Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbYCVAQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbYCVAQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 20:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYCVAQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 20:16:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:35400 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYCVAQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 20:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c4Inl/uIkI1w3GPxyWPkYy2wl6hAMsqS2FfmHIr9y2eMwpVdGWjMjofOf5Q1BT/fJ+lrxa7sXRfF0M5RtkKV9xewHMqDPBtXKmuoCaVbNh7Fgv9iBI6AwyGW/qI4tWXc8XijycdzZS3w/9Vg3tj68SHUEc4uXUxa5h+ailLKvxQ=
Message-ID: <9a8748490803211716j333f40f1vdf9d1ffd0c67448c@mail.gmail.com>
Date: Sat, 22 Mar 2008 01:16:42 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Cc: chrisw@sous-sol.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
In-Reply-To: <20080321.171401.49157146.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080321224250.144333319@sous-sol.org>
	 <20080321224333.400857992@sous-sol.org>
	 <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
	 <20080321.171401.49157146.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/2008, David Miller <davem@davemloft.net> wrote:
> From: "Jesper Juhl" <jesper.juhl@gmail.com>
>  Date: Sat, 22 Mar 2008 01:10:40 +0100
>
>
>  > As I see it, this patch is quite trivial and does not fix any "real problem".
>  > How come this is suitable for -stable?
>  >
>  > I have no objections to the patch "as such", I just don't think it
>  > makes sense for -stable.
>
>
> It makes a difference for driver maintainers when users
>  report bugs and we ask them for the version printed
>  by the driver so that we know which fixes have been
>  applied.
>
Ok, fair enough.

>  You know, if people are going to be jerky about this,
>  I'll just include the version bump in the actual bug
>  fixes which I sometimes do anyways.
>
>  Thanks for bringing this up, it's a useful use of
>  everyone's time :-/
>
Excuse me for reading patches, trying to spot problems and thinking
about where they are applied and what rules apply etc.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
