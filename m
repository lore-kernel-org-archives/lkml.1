Return-Path: <linux-kernel-owner+w=401wt.eu-S1423231AbXBITff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423231AbXBITff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992776AbXBITff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:35:35 -0500
Received: from colin.muc.de ([193.149.48.1]:1071 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423231AbXBITff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:35:35 -0500
Date: 9 Feb 2007 20:35:33 +0100
Date: Fri, 9 Feb 2007 20:35:33 +0100
From: Andi Kleen <ak@muc.de>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, vojtech@suse.cz
Subject: Re: [PATCH 18/34] __initdata cleanup - x86_64
Message-ID: <20070209193533.GA79395@muc.de>
References: <200702091711.34441.alon.barlev@gmail.com> <200702091724.28770.alon.barlev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702091724.28770.alon.barlev@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 05:24:28PM +0200, Alon Bar-Lev wrote:
> 
> Trivial.

What is this change good for?

I didn't think any x86_64 binutils had trouble with bss initdata

-Andi
