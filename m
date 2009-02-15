Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZBOWRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZBOWRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZBOWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:16:52 -0500
Received: from eazy.amigager.de ([213.239.192.238]:53725 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZBOWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:16:51 -0500
Date: Sun, 15 Feb 2009 23:16:47 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Bug #12401] 2.6.28 regression: xbacklight broken on ThinkPad
	X61s
Message-ID: <20090215221647.GA15392@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
	Thomas Renninger <trenn@suse.de>, Zhang Rui <rui.zhang@intel.com>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.FEB.M50lJB@chimera> <20090215134409.GC21670@srcf.ucam.org> <200902151538.29766.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902151538.29766.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 15:38:28 +0100, Rafael J. Wysocki wrote:
> On Sunday 15 February 2009, Matthew Garrett wrote:
> > This one sounded like a configuration error.

I think if it works without DRI in 2.6.27 and doesn't work in 2.6.28,
it isn't a configuration error, but a real regression.

Regards,
Tino
