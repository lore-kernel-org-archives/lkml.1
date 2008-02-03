Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbYBCPMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbYBCPMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 10:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYBCPL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 10:11:59 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33931 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYBCPL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 10:11:58 -0500
Message-ID: <47A5D9CD.5070001@davidnewall.com>
Date: Mon, 04 Feb 2008 01:42:13 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
In-Reply-To: <20080202191930.GA19826@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> It comes down to the simple fact, if you wish to use Linux, abide by the
> license it comes under.  To do otherwise is both disenginous and
> illegal[1].
By the way, I'm almost certain that the COPYING file is the first, last
and only document specifying licence conditions, and nothing in that
prevents a proprietary driver from including a patch that, for example,
globally replaces ALL GPL-only symbols by the less restrictive ones.  In
fact, you'd be in a bit of strife down under if you tried to say
otherwise.  We've got quite strong consumer protection laws down here. 
You're just not allowed to claim additional licence conditions based on
source code commentary.

It's just games and hot air, isn't it?
