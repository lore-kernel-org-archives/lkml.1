Return-Path: <linux-kernel-owner+w=401wt.eu-S1765569AbXF1Uj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765569AbXF1Uj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762550AbXF1UjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:39:04 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39622 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761719AbXF1UjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:39:03 -0400
Date: Thu, 28 Jun 2007 22:38:58 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Antonino Ingargiola <tritemio@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Possible BUG] Logitech USB keyboard inconsistent led state
In-Reply-To: <5486cca80706281309q473c6300l6bd221c361d3f5df@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706282238270.31463@twin.jikos.cz>
References: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com> 
 <Pine.LNX.4.64.0706272144280.9610@twin.jikos.cz> 
 <5486cca80706280059pabcaa59u7f44440134490590@mail.gmail.com> 
 <Pine.LNX.4.64.0706281923230.31463@twin.jikos.cz>
 <5486cca80706281309q473c6300l6bd221c361d3f5df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Antonino Ingargiola wrote:

> Tried on 2.6.22-rc6-cfs18 and it works, thanks :)
> Now the led is off by default on boot but the state is consistent.
> Can we have this patch in 2.6.22?
> (Feel free to add a Tested off with my name is this make any sense in
> this case).

I will queue it in my tree for next upstream merge, thanks.

-- 
Jiri Kosina
