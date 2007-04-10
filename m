Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXDJOGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXDJOGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbXDJOGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:06:36 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:47255 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbXDJOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:06:34 -0400
Date: Tue, 10 Apr 2007 15:06:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070410140617.GA5255@srcf.ucam.org>
References: <20070405141352.12fddb6e@the-village.bc.nu> <20070406163707.GA25880@srcf.ucam.org> <20070409222241.6581ecc2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409222241.6581ecc2@the-village.bc.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] HPA support: Revised patch
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 10:22:41PM +0100, Alan Cox wrote:

> Please apply Tejun's fix for LBA48 data and try again. Hopefully its just
> that which is causing the problem.

Yes, that works absolutely fine now.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
