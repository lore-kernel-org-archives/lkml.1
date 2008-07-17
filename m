Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbYGQWkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbYGQWkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbYGQWkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:40:43 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38792 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118AbYGQWkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:40:42 -0400
Date: Thu, 17 Jul 2008 18:40:41 -0400
To: Alastair Stevens <alastair@altrux.me.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080717224041.GM31126@csclub.uwaterloo.ca>
References: <487FC213.9030604@altrux.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487FC213.9030604@altrux.me.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:05:07PM +0100, Alastair Stevens wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Forgive me if I missed it, but I've not seen any suggestions along the lines
> of this: how about just dropping the now-meaningless '.6' from the version
> string and retaining the rest. In other words:
> 
>    2.27
>    2.27.1
>    ...
>    2.28
>    2.28.1
>    2.28.2
> 
> That way you continue the series in a meaningful way, whilst reverting to a
> neater 3-level numbering scheme again. Perhaps you could make 2.[6.]30 the
> switchover point....

So what makes the 6 meaningless and the 2 meaningful and worth keeping?

It does nothing for Linus's dislike of large numbers either.

-- 
Len Sorensen
