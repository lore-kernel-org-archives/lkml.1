Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbXLDT6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbXLDT6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXLDT6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:58:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:57165 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbXLDT6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:58:39 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linuxppc-dev@ozlabs.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0712041337530.12181@pademelon.sonytel.be>
References: <20071204060911.EA82BDDE19@ozlabs.org>
	 <Pine.LNX.4.62.0712041337530.12181@pademelon.sonytel.be>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 06:57:59 +1100
Message-Id: <1196798279.13230.312.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-04 at 13:39 +0100, Geert Uytterhoeven wrote:
> 
> Can we please have them in <linux/ioport.h>? They look very useful to
> me
> elsewhere (other bus drivers, device drivers), too.
> 
> What about naming the printf format specifier macros more like in C99,
> e.g.
> PRI*?

That's a can of worms I just didn't want to open...

Ben.


