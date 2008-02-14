Return-Path: <linux-kernel-owner+w=401wt.eu-S1764517AbYBNG23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764517AbYBNG23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBNG2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:28:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36828 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYBNG2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:28:21 -0500
Date: Wed, 13 Feb 2008 22:30:39 -0800
From: Greg KH <greg@kroah.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] PCI: remove initial bios sort of PCI devices on x86
Message-ID: <20080214063039.GA2543@kroah.com>
References: <20080213234029.GA5119@kroah.com> <20080214050753.GA28584@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214050753.GA28584@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:07:53PM -0600, Matt Domsch wrote:
> On Wed, Feb 13, 2008 at 03:40:29PM -0800, Greg KH wrote:
> 
> Good plan.  I'll be glad when the vestigal internal PCI device list is
> gone too.

With this patch, it's the last major step, I have a series of follow-up
patches that will remove it entirely.  I'll post them when they've been
tested better.

thanks,

greg k-h
