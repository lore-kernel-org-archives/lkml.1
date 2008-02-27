Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYB0P4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYB0P4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYB0P4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:56:38 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:51120 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYB0P4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:56:38 -0500
Date: Wed, 27 Feb 2008 15:55:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stefan Seyfried <seife@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20080227155552.GA31341@srcf.ucam.org>
References: <20080225225820.GP2659@elf.ucw.cz> <20080226215641.GE10280@elf.ucw.cz> <20080227131227.GB28528@srcf.ucam.org> <200802271423.12208.rjw@sisk.pl> <47C586F1.2030803@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C586F1.2030803@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 04:51:13PM +0100, Stefan Seyfried wrote:
> Rafael J. Wysocki wrote:
> > He probably meant that the s2ram _whitelist_ is going to be deprecated, which
> > didn't mean s2ram altogether.
> 
> Exactly.

Ah! My apologies, I managed to misunderstand that.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
