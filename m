Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYHZBIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYHZBIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 21:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYHZBI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 21:08:28 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35580 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYHZBI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 21:08:28 -0400
Message-ID: <48B35788.4020008@skyrush.com>
Date: Mon, 25 Aug 2008 19:08:24 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Willy Tarreau <w@1wt.eu>, Chris Frey <cdfrey@foursquare.net>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Visible Ctrl-C in latest kernels
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu> <48B2EDC2.1020608@davidnewall.com> <48B2F3E9.5020804@skyrush.com>
In-Reply-To: <48B2F3E9.5020804@skyrush.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson wrote:
> When I run your program, foreground or background, it always completes
> (i.e. 5 "." chars) - i.e., I cannot interrupt it before it finishes.
> This seems different than what you see.
> 
> Given the nature of the bash issue, it does not seem related, at least
> not directly.

Ah, but forgot to add: what you are seeing sounds like it warrants
investigation.  If you find anything more on this (or if I am not reproducing
your results correctly), let me know.

					-Joe
