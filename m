Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbXBLGNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbXBLGNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXBLGNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:13:55 -0500
Received: from paragon.brong.net ([66.232.154.163]:37904 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027AbXBLGNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:13:54 -0500
Date: Mon, 12 Feb 2007 17:13:47 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.40
Message-ID: <20070212061347.GB24889@brong.net>
References: <20070210164113.GG12958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210164113.GG12958@stusta.de>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 05:41:13PM +0100, Adrian Bunk wrote:
> New drivers since 2.6.16.39:
> - Areca ARC11X0/ARC12X0 SATA-RAID support
> - AMD Athlon64/FX and Opteron temperature sensor

Sorry - I think I just sent a blank reply to this!  Oops.

I was going to say - thanks.  We'll definitely be using
this kernel since we've found that 2.6.19.2 has a
significantly worse IO profile and either the 2.6.16.40-rc1
kernel or 2.6.18 on otherwise identical machines with pretty
stable loads (so we can compare back to previous weeks).

Now to figure out what's causing the extra load in the
2.6.19 branch!

Bron.
