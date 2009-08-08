Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZHHBDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZHHBDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZHHBDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:03:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:52416 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbZHHBDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:03:08 -0400
Date: Sat, 8 Aug 2009 03:03:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Christian Thaeter <ct@pipapo.org>
Subject: Re: [PATCH 2/2] hpfall: accept disk device to unload as argument
In-Reply-To: <20090725204838.GA2246@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.0908080301550.25797@wotan.suse.de>
References: <200907252055.16416.elendil@planet.nl> <200907252100.14175.elendil@planet.nl> <20090725204838.GA2246@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009, Pavel Machek wrote:

> On Sat 2009-07-25 21:00:12, Frans Pop wrote:
> > Allows users who use an IDE driver for their disk to use hpfall without
> > having to modify the source. By default /dev/sda is used.
> > Suggested by Christian Thaeter in http://lkml.org/lkml/2009/3/25/505.
> > 
> > While we're add it, improve error message if opening /dev/freefall fails.
> > 
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> > Cc: Pavel Machek <pavel@ucw.cz>
> 
> ACK.

Queued, thanks.

-- 
Jiri Kosina
SUSE Labs
