Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXCIADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXCIADo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXCIADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:03:43 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:60807 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbXCIADm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:03:42 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: RSDL test
Date: Fri, 9 Mar 2007 11:03:34 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070308140822.GA3392@kernel.dk>
In-Reply-To: <20070308140822.GA3392@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091103.34775.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 01:08, Jens Axboe wrote:
> Hi Con,
>
> One thing that has annoyed me greatly lately, is that scrolling in
> firefox very quickly becomes a huge pain if you have any load on your
> box. I typically do make -j4 kernel builds on my laptop (core duo), and
> try to stay out of firefox for that period simply because it's not very
> responsive (to the point of being really annoying). A pseudo test of
> running two
>
> $ while true; do a=1; done
>
> produces the same result, firefox is unusable.
>
> So seeing your post, I gave it a spin. Works great for me, much better
> than the stock 2.6.21-rc3 wrt interactive feel. I know this is a
> subjective test, but believe me, there's a world of difference.

Great! Sometimes there are things that simply cannot be benchmarked 
objectively and subjectively is all we have to go on as you're no doubt well 
aware. Interbench simply confirms that rsdl is _less unfair_ than mainline. 
It doesn't tell us about getting the rest of the picture right as often as 
possible which is really what rsdl is all about.

Thanks for your feedback :)

-- 
-ck
