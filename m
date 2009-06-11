Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbZFKOG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbZFKOG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZFKOGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:06:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55181 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZFKOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:06:46 -0400
Date: Thu, 11 Jun 2009 15:06:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611140624.GS795@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk> <20090611140038.GB11199@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611140038.GB11199@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:00:39AM -0700, Tony Lindgren wrote:
> You suggested pulling each set as they get reviewed into some omap branch
> in your tree, do you want to try that the next merge window?

If we're following Alan's suggestion, then as I see it you're entirely
responsible for tracking what's in OMAP, getting it into linux-next and
(I guess) ultimately sending Linus a pull request for it during the
merge window.  I just become someone who can put their oar into reviewing
OMAP patches as and when.

So the question is: do you want to give this a go?
