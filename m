Return-Path: <linux-kernel-owner+w=401wt.eu-S1763191AbXEVJWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191AbXEVJWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbXEVJVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:21:51 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:49490 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbXEVJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:21:50 -0400
Date: Tue, 22 May 2007 10:16:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, trenn@suse.de,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Message-ID: <20070522091631.GA23309@srcf.ucam.org>
References: <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <20070522090636.GO10714@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522090636.GO10714@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:06:36AM +0200, Pavel Machek wrote:

> We need to ignore trip point updates from BIOS, and we need to poll
> thermals when use overrides trip points. That's expected. Plus I've
> yet to see platform actually updating the trip points.

Try any recent HP bios.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
