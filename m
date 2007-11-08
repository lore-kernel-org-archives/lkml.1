Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbXKHSWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbXKHSWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761190AbXKHSWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:22:46 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:41709 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963AbXKHSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:22:44 -0500
Date: Thu, 8 Nov 2007 18:22:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, roppedisano@infracomspa.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, rjw@sisk.pl,
       linux-acpi@vger.kernel.org
Message-ID: <20071108182217.GA2685@srcf.ucam.org>
References: <4731C86B.1040704@infracomspa.it> <20071107121355.5eaf4496.akpm@linux-foundation.org> <47333CCF.1050403@infracomspa.it> <20071108094958.5c9b1b22.akpm@linux-foundation.org> <20071108180256.GB3491@havoc.gtf.org> <20071108101341.6c4f88d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108101341.6c4f88d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 10:13:41AM -0800, Andrew Morton wrote:

> I suspect it wold be best to disable the feature for the 2.6.24 release,
> then reenable it afterwards and keep doing this until the code is
> sufficiently stable.

GTF method execution failure currently looks like it's fatal, when it 
probably shouldn't be. I'll send a patch shortly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
