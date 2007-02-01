Return-Path: <linux-kernel-owner+w=401wt.eu-S1422697AbXBAIrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422697AbXBAIrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422703AbXBAIrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:47:09 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:3347 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422697AbXBAIrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:47:08 -0500
Message-ID: <45C1A8D7.6010100@jonmasters.org>
Date: Thu, 01 Feb 2007 03:46:15 -0500
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi[sz]ation Of Broken Dreams
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: New module-init-tools pre-release (v3.3-pre6)
References: <45C188AB.1060207@jonmasters.org>	<20070131231731.4b88d8f6.akpm@osdl.org>	<20070201081036.GC32510@dallas.jonmasters.org> <20070201003450.f0164d3e.akpm@osdl.org>
In-Reply-To: <20070201003450.f0164d3e.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> No, I was thinking of a record which explicitly mentions module-init-tools.
> It's not a part of the kernel, but it is closely connected to it, and this is
> useful information to have in ./MAINTAINERS.

Ah, now that makes more sense. I was thinking you were thinking of an 
existing entry. Meh, anyway, way too late in the evening for thought.

> The patch you sent claims that you maintain kernel/module.c.

Indeed, which I don't want to. Rusty can keep that one for now :-)

Jon.
