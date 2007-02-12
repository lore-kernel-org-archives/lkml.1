Return-Path: <linux-kernel-owner+w=401wt.eu-S964848AbXBLLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbXBLLNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964847AbXBLLNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:13:20 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:57124 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848AbXBLLNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:13:18 -0500
Date: Mon, 12 Feb 2007 11:12:47 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Ben Dooks <ben-linux@fluff.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] mfd: SM501 core driver
Message-ID: <20070212111247.GE19392@home.fluff.org>
References: <20070206192628.GA13644@fluff.org.uk> <20070206210930.fc814bf6.akpm@linux-foundation.org> <20070207114825.GA21120@fluff.org.uk> <20070207085225.c2371cfd.akpm@linux-foundation.org> <20070207170949.GD21120@fluff.org.uk> <Pine.LNX.4.64.0702081755290.7686@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702081755290.7686@pentafluge.infradead.org>
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

5BOn Thu, Feb 08, 2007 at 05:56:02PM +0000, James Simmons wrote:
> 
> 
> Do you have a new patch?

New mfd driver posted to the linux-kernel list. Will post
new sm501 driver (fixed cursor code) and option for byte-swap
on systems with big-endian cpu and little-endian pci

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
