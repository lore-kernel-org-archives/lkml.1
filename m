Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXKNKTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXKNKTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXKNKS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:18:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56420
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbXKNKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:18:56 -0500
Date: Wed, 14 Nov 2007 02:18:55 -0800 (PST)
Message-Id: <20071114.021855.242406994.davem@davemloft.net>
To: kaber@trash.net
Cc: rainer.jochem@mpi-sb.mpg.de, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pcernko@mpi-sws.mpg.de
Subject: Re: [PATCH] ipconfig.c : implement DHCP Class-identifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <473AC47B.9070509@trash.net>
References: <473AB82F.8050801@trash.net>
	<20071114094508.GA6004@mpi-sb.mpg.de>
	<473AC47B.9070509@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 14 Nov 2007 10:48:43 +0100

> Rainer Jochem wrote:
> > 
> >> I don't think its very useful since you can simply get this information
> >> from /proc/cmdline in case something goes wrong, but if you insist at
> >> least give it a meaningful prefix.
> > 
> > Added.
> > 
> >> The initialization is unnecessary.
> > 
> > Removed.
> > 
> >> Should be >= I think.
> > 
> > Fixed.
> 
> Looks fine, thanks.

Applied to net-2.6.25, thanks everyone.
