Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYLKJ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYLKJ03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYLKJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:26:19 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:1147 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbYLKJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:26:19 -0500
Date: Thu, 11 Dec 2008 10:26:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211102604.28f148ff@hyperion.delvare>
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 10 Dec 2008 17:04:39 -0800 (PST), Linus Torvalds wrote:
> Perhaps more interesting is simply the release scheduling issue. I'm 
> getting slowly ready to do a real 2.6.28, but I don't think anybody really 
> wants the merge window to be around the holidays. So the question is 
> really whether to 
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> 
>      I like this, because alledgely people are debugging things, and we'd 
>      get a more stable 2.6.28.

I vote for option (a).

> 
> or
> 
>  (b) release in a week or two, but just allow for possibly extending the 
>      merge window due to people being drunk on eggnog..
> 
>      I like this because let's face it, we get more and better bug 
>      information after releases, and everything _should_ be ready for 
>      merging *before* the merge window anyway.
> 
> or
> 
>  (c) some other crazy scheme that somebody comes up with in a drug-induced 
>      stupor.
> 
> So I haven't quite decided on that thing yet, but I'm open to suggestions. 

-- 
Jean Delvare
