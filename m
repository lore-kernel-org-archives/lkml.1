Return-Path: <linux-kernel-owner+w=401wt.eu-S1422956AbXBATTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422956AbXBATTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422955AbXBATTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:19:04 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:57121 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422954AbXBATTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:19:03 -0500
Date: Thu, 1 Feb 2007 20:19:01 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Stephen Hemminger <shemminger@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070201191901.GP13130@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Stephen Hemminger <shemminger@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	shemminger@linux-foundation.org, netdev@vger.kernel.org
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de> <20070201110552.5bf52c8f@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201110552.5bf52c8f@localhost>
User-Agent: Mutt/1.5.11-2006-07-11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

> It was intentional in 2.6 to allow interfaces to be hot-removed.
> Remember with Internet protocols there is no hard binding (normally)
> between address and device and connections should not go down if link
> fails.

of course. That makes sense. I just wondered when the change in mind
happened. And actually I like this behaviour.

> > With that everything works. If somone is interested in my userland
> > watchdog, just send me an E-Mail.

> Hopefully, it won't be necessary for long.

So do I.

        Thomas
