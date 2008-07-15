Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbYGOC2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbYGOC2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYGOC2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:28:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbYGOC2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:28:02 -0400
Date: Mon, 14 Jul 2008 19:27:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487C242B.19490.17F690F7@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <486D4541.25808.C600354@pageexec.freemail.hu>, <20080714120418.GA5334@kroah.com> <487C242B.19490.17F690F7@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> 
> so guys (meaning not only Greg but Andrew, Linus, et al.), when will you
> publicly explain why you're covering up security impact of bugs? and even
> more importantly, when will you change your policy or bring your process
> in line with what you declared?

We went through this discussion a couple of weeks ago, and I had 
absolutely zero interest in explaining it again.

I personally don't like embargoes. I don't think they work. That means 
that I want to fix things asap. But that also means that there is never a 
time when you can "let people know", except when it's not an issue any 
more, at which point there is no _point_ in letting people know any more.

So I personally consider security bugs to be just "normal bugs". I don't 
cover them up, but I also don't have any reason what-so-ever to think it's 
a good idea to track them and announce them as something special. 

So there is no "policy". Nor is it likely to change. 

			Linus
