Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYEIVoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYEIVoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYEIVoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:44:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34957
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbYEIVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:44:04 -0400
Date: Fri, 09 May 2008 14:43:59 -0700 (PDT)
Message-Id: <20080509.144359.194792251.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jeff@garzik.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805090805210.3142@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805081848170.2940@woody.linux-foundation.org>
	<4824606E.3040409@garzik.org>
	<alpine.LFD.1.10.0805090805210.3142@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 May 2008 08:05:47 -0700 (PDT)

> On Fri, 9 May 2008, Jeff Garzik wrote:
> > 
> > The e1000e change is just a bunch of code additions for a new phy type, not a
> > bunch of /changes/ really.  Is that the change you're concerned with?
> 
> Yes. I saw 800 new lines to a driver I use, and I go "Ugh".

And if it enabled support for a device you have, for which you've been
patching the driver for some time, you'd go "Yippie!" :-)))

BTW, this reminds me, did we get that driver in for the device the
EEPC machines use?  I have this strange feeling like that slipped
through the cracks.

