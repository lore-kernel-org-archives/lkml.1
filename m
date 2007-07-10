Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbXGKKss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbXGKKss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXGKKsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:48:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:50106 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbXGKKsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:48:39 -0400
Date: Tue, 10 Jul 2007 14:53:36 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: olof@lixom.net (Olof Johansson)
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Message-ID: <20070710145336.6f8b5770@localhost.localdomain>
In-Reply-To: <20070707150147.GA2202@lixom.net>
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
	<20070707150147.GA2202@lixom.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 7 Jul 2007 10:01:47 -0500
Olof Johansson wrote:

> On Sat, Jul 07, 2007 at 01:48:52PM +0400, Vitaly Bordug wrote:
> > 
> > This adds support for MMIO IDE device like CompactFlash 
> > in TrueIDE mode.
> 
> Doesn't this duplicate most of pata_platform, but as the
> no-longer-preferred legacy IDE device? Did you try using
> pata_platform instead?
> 
prolly true,
but as Sergei told upper, that's not an option so far due to internal reasons. But it is likely to be followed-up
that way a little bit later.

> 
> -Olof


-- 
Sincerely, Vitaly

-- 
Sincerely, Vitaly
