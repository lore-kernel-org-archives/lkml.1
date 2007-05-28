Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbXE1Muv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbXE1Muv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXE1Mun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:50:43 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60681 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXE1Mun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:50:43 -0400
Date: Mon, 28 May 2007 13:50:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-ID: <20070528125035.GA29738@srcf.ucam.org>
References: <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <1180016213.16396.74.camel@queen.suse.de> <20070524143644.GA27364@srcf.ucam.org> <20070525063815.GA3989@ucw.cz> <20070527215123.GA22687@srcf.ucam.org> <20070528105851.GE18807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528105851.GE18807@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace - Was: [cannot change thermal trip points]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 12:58:51PM +0200, Pavel Machek wrote:

> It would happily occur under Windows. You just needed to load machine
> in a way that cpu stayed ~80C.

So replace the DSDT. All the problems get solved that way.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
