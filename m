Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYE2NaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYE2NaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYE2NaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:30:10 -0400
Received: from ns.suse.de ([195.135.220.2]:58067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYE2NaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:30:09 -0400
Date: Thu, 29 May 2008 15:33:02 +0200
From: Holger Macht <hmacht@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080529133302.GA9268@homac.suse.de>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
	linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529132253.GA22309@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29. May - 14:22:53, Matthew Garrett wrote:
> Hm. This deadlocks my Thinkpad when I pull a device from the internal 
> bay.

Can you please give a bit more details? Does your userspace react on the
eject request? I tested with Thinkpads, too.

 - Holger

