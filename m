Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbXHCVeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbXHCVeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762453AbXHCVdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:33:52 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:46892 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762440AbXHCVdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:33:52 -0400
Date: Fri, 3 Aug 2007 22:33:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net
Message-ID: <20070803213332.GA27221@srcf.ucam.org>
References: <20070803201239.GB20376@redhat.com> <Pine.LNX.4.44L0.0708031716030.5099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708031716030.5099-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 05:17:24PM -0400, Alan Stern wrote:

> The last report appears to be related more to the EHCI-cpufreq problem, 
> for which a patch was recently posted.

There seem to be multiple issues there, with at least one of them being 
autosuspend related.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
