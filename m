Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbZFKN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbZFKN3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZFKN3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:29:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFKN3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:29:08 -0400
Date: Thu, 11 Jun 2009 14:28:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611132846.GO795@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 01:54:42PM +0100, Alan Cox wrote:
> Leave it to the platform people to push their driver code through the
> right channels.

I should point out that that has been entirely the case since switching
over to BK, and later git.  I do not merge other driver code into my
tree unless the subsystem maintainer wants me to do so, in which case I
do give it a quick review.  Sometimes I give people a quick review on
the way to directing them to the right places.

I do hope you don't think I still run that unmanagable -rmk tree that
was around when you did the -ac series kernels.  I gave that up as a
bad approach a very long time ago.
