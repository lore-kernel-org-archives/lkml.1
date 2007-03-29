Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXC2KgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXC2KgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934061AbXC2KgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:36:05 -0400
Received: from colin.muc.de ([193.149.48.1]:4751 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934302AbXC2KgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:36:04 -0400
Date: 29 Mar 2007 12:36:02 +0200
Date: Thu, 29 Mar 2007 12:36:02 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Gerd Hoffmann <kraxel@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ignore vgacon if hardware not present
Message-ID: <20070329103602.GB52274@muc.de>
References: <1175154408.12230.195.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175154408.12230.195.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 05:46:48PM +1000, Rusty Russell wrote:
> (Did this fall through the cracks?  I don't see it in -mm.  It's
> standalone, and saves some silly code in lguest and presumably others).

Normally it should go to some some console maintainer? 

Ok I can add it.

-Andi
