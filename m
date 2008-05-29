Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYE2Nkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYE2Nkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYE2Nkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:40:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52488 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYE2Nkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:40:39 -0400
Date: Thu, 29 May 2008 14:40:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Message-ID: <20080529134019.GA22738@srcf.ucam.org>
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <20080529133302.GA9268@homac.suse.de> <20080529133201.GA22476@srcf.ucam.org> <20080529133921.GB9268@homac.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529133921.GB9268@homac.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running with init=/bin/bash, I still get it. The only kernel output I 
get is libata telling me that the device is disabled, and the machine is 
dead after that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
