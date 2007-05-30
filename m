Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXE3BCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXE3BCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXE3BCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:02:39 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:34523 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXE3BCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:02:39 -0400
Date: Wed, 30 May 2007 02:02:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Message-ID: <20070530010222.GA22266@srcf.ucam.org>
References: <20070527190351.GA21387@srcf.ucam.org> <20070527233911.GA23491@srcf.ucam.org> <20070528003822.GA23759@srcf.ucam.org> <200705271844.54589.david-b@pacbell.net> <20070528172418.GA2076@srcf.ucam.org> <pan.2007.05.28.18.50.22@free.fr> <20070529173058.c003e18c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529173058.c003e18c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] RTC: Use fallback IRQ if PNP tables don't provide one
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 05:30:58PM -0700, Andrew Morton wrote:

> Matthew didn't reply to this, almost surely because you removed him
> (and David) from the cc.  Please don't ever do that.

Ah, I saw this on linux-acpi and replied to it there. There's no entries 
in the options file and the resources one lists no IRQ.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
