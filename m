Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbXEVWqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbXEVWqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXEVWqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:46:25 -0400
Received: from waste.org ([66.93.16.53]:42396 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbXEVWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:46:24 -0400
Date: Tue, 22 May 2007 17:45:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070522224515.GW11115@waste.org>
References: <20070519165738.GK11115@waste.org> <20070519204504.GA24704@khazad-dum.debian.net> <20070519223843.GN11115@waste.org> <20070520035259.GA13224@khazad-dum.debian.net> <20070521222339.GF11115@waste.org> <20070521230349.GA645@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521230349.GA645@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 08:03:49PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 21 May 2007, Matt Mackall wrote:
> > BIOS Information
> >         Vendor: IBM
> >         Version: 1RETDHWW (3.13 )
> >         Release Date: 10/29/2004
> > 
> > No sign of any EC version in the output.
> 
> This is a buggy, ancient version of the BIOS, which probably means you have
> an old and slightly buggy EC firmware.  I recommend you to upgrade to BIOS
> 3.21 and EC 3.04.  See http://thinkwiki.org/wiki/BIOS_Upgrade for more
> details.

Really, I'd much prefer my kernel not regress instead. Updating
firmware is just introducing more potential instability and ignoring
the problem.

-- 
Mathematics is the supreme nostalgia of our time.
