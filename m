Return-Path: <linux-kernel-owner+w=401wt.eu-S933385AbXK2TYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385AbXK2TYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbXK2TYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:24:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:19535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761478AbXK2TYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:24:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,230,1194249600"; 
   d="scan'208";a="236403167"
Date: Thu, 29 Nov 2007 11:22:20 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: ahci: Enclosure Management via LED
Message-ID: <20071129112220.55310ff5@appleyard>
In-Reply-To: <474F01E7.5040101@rtr.ca>
References: <20071129094802.49e729ed@appleyard>
	<474F01E7.5040101@rtr.ca>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 13:16:07 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Kristen wrote:
> ...
> >+	 * XXX will need Port Multiplier support
> 
> What's that all about ?
> 

I didn't have any hardware that had LED support as well as Port
Multiplier, so I didn't implement port multiplier support for this.  I
wasn't sure if it was better to just do it anyway, or leave it for when
we actually have hardware that needs it.
