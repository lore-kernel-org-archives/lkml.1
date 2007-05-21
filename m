Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbXEUXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbXEUXTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbXEUXTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:19:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46258 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbXEUXTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:19:05 -0400
Message-ID: <465228E2.1030405@garzik.org>
Date: Mon, 21 May 2007 19:18:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>	 <200705210914.22663.jbarnes@virtuousgeek.org>	 <200705210934.58559.jbarnes@virtuousgeek.org> <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
In-Reply-To: <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> 2) Address the long outstanding issue of multi-seat at the console
> level. My solution to this is the one device per CRTC model.

This is very very low priority.  Pretty much nobody besides you is 
clamoring for it.


> 3) Eliminate the need for a root priv controlling process. Get rid of
> the potential for a security hole.

Agreed.


> 4) OOPS should always display even if in a graphics mode

Agreed, and this was in the list that Jesse(?) posted.


> 8) Allow multiple user space graphics systems to run. These user space

Another very very low priority item.

There are a lot more important things to work on.  Linux is about what 
people need -right now-, not what you think Linux might need in the 
future; not what you think might be nice to have.

	Jeff


