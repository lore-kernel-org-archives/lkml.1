Return-Path: <linux-kernel-owner+w=401wt.eu-S965761AbXJSR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965761AbXJSR6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765767AbXJSR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:58:34 -0400
Received: from www.tglx.de ([62.245.132.106]:52998 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765361AbXJSR6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:58:33 -0400
Date: Fri, 19 Oct 2007 19:58:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlos Corbacho <cathectic@slackadelic.com>
cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Force enable HPET for CK804 (nForce 4) chipsets
In-Reply-To: <200710191851.28639.cathectic@slackadelic.com>
Message-ID: <alpine.LFD.0.9999.0710191957420.22770@localhost.localdomain>
References: <200710190423.31714.cathectic@slackadelic.com> <200710191629.11526.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710191736280.22770@localhost.localdomain> <200710191851.28639.cathectic@slackadelic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Carlos Corbacho wrote:
> From: Carlos Corbacho <cathectic@gmail.com>
> 
> This patch adds a quirk from LinuxBIOS to force enable HPET on
> the nVidia CK804 (nForce 4) chipset.
> 
> This quirk can very likely support more than just nForce 4
> (LinuxBIOS use the same code for nForce 5), and possibly nForce 3,
> but I don't have those chipsets, so cannot add and test them.
> 
> Tested on an Abit KN9 (CK804).
> 
> Signed-off-by: Carlos Corbacho <cathectic@gmail.com>

Applied. Thanks,

	tglx
