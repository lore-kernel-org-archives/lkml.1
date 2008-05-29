Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYE2OCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYE2OCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYE2OCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:02:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37954 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYE2OCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:02:33 -0400
Date: Thu, 29 May 2008 15:02:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Message-ID: <20080529140213.GA23373@srcf.ucam.org>
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <483EB33D.6010101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483EB33D.6010101@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:44:29PM +0900, Tejun Heo wrote:
> Does this fix the problem?

No, I'm seeing an identical hang. Mainline works fine.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
