Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0CJPsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:48:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44966 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab0CJPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:48:00 -0500
Date: Wed, 10 Mar 2010 15:47:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Evan McClain <evan.mcclain@gatech.edu>, rpurdie@rpsys.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook
	variants
Message-ID: <20100310154752.GA23027@srcf.ucam.org>
References: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu> <20100310142424.GA21625@srcf.ucam.org> <4B97BEA7.8010804@inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B97BEA7.8010804@inf.tu-dresden.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 04:45:43PM +0100, Mario Schwalbe wrote:

> Tested using a simple program that writes the ports from userland.
> And ack: it should probably be renamed to something more reasonable.
> Something like apple_bl?

Sure. Want to do a patch for that and Kconfig? It probably wants a 
module alias line for backwards compatibility.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
