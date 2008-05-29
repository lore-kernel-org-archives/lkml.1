Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYE2Nc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYE2Nc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYE2NcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:32:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42407 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYE2NcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:32:17 -0400
Date: Thu, 29 May 2008 14:32:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Message-ID: <20080529133201.GA22476@srcf.ucam.org>
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <20080529133302.GA9268@homac.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529133302.GA9268@homac.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 03:33:02PM +0200, Holger Macht wrote:

> Can you please give a bit more details? Does your userspace react on the
> eject request? I tested with Thinkpads, too.

No, I'm not doing anything with userspace - just pulling the drive out 
directly. I'm looking into it now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
