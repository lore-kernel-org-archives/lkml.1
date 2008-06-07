Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYFGOLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYFGOLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbYFGOLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:11:19 -0400
Received: from smtp2.wanadoo.co.uk ([193.252.22.157]:63989 "EHLO
	smtp2.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYFGOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:11:18 -0400
X-ME-UUID: 20080607141110823.C8EF17000082@mwinf3101.me.freeserve.com
Date: Sat, 7 Jun 2008 15:10:54 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: pppd and 2.6.25 serial driver
Message-ID: <20080607151054.5d2b76e0@boulder.homenet>
In-Reply-To: <20080606110928.2e034c26@core>
References: <20080601215621.256db193@boulder.homenet>
 <20080605222355.be299fff.akpm@linux-foundation.org>
 <20080606110928.2e034c26@core>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 11:09:28 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> No relevant changes, and the 2.6.26 stuff isn't a trivial backport or
> relevant either that I can see. Also it seems to work for everyone
> else which makes me suspicious.

Who uses internet dial-up these days?  However, it could be something
odd about my hardware, which is a laptop using via chipsets, but it
is also ppp specific, as I can receive faxes with a fax modem using the
2.6.25 serial driver.

Anyway, I have checked with the serial driver in the latest 2.6.26
(2.6.26-rc5) and that still works fine with ppp.

Chris

