Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXGaUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXGaUPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbXGaUPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:15:20 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:52739 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbXGaUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:15:18 -0400
Date: Tue, 31 Jul 2007 16:14:59 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] documentation fixes
In-Reply-To: <200707311114.09308.philipp.marek@bmlv.gv.at>
Message-ID: <Pine.LNX.4.64.0707311606350.13917@lancer.cnet.absolutedigital.net>
References: <200707311114.09308.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, Ph. Marek wrote:

> Hello everybody,
> 
> here are some small documentation fixes - mostly typing errors.
> 
> Please take a look at the last chunk - I think that klibc.bkbits.net 
> is no longer the current version, but I'm not sure whether the 
> other link is better.

git://git.kernel.org/pub/scm/libs/klibc/klibc.git should be a safe 
replacement

> Whom should I CC for other documentation updates? Is the maintainer 
> the correct person, or are such small fixes "send and forget"?

For spelling and grammar fixes, sending to trivial@kernel.org is prolly 
the best bet with a CC to l-k.

Also, please see Documentation/SubmittingPatches, particularly section 12 
about signing off your work.

cheers,
-- 
Cal Peake

