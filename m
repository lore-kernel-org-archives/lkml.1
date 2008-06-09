Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYFIVYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYFIVYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYFIVX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:23:58 -0400
Received: from tim.rpsys.net ([194.106.48.114]:60841 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbYFIVX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:23:57 -0400
X-Greylist: delayed 1456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 17:23:56 EDT
Subject: Re: [PATCH v2] Add backlight driver for Nvidia-based Apple Macbook
	Pros
From: Richard Purdie <rpurdie@rpsys.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080609000554.GA28782@srcf.ucam.org>
References: <20080607025436.GB24254@srcf.ucam.org>
	 <20080608183255.GB3580@tango.0pointer.de>
	 <20080609000554.GA28782@srcf.ucam.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 21:59:31 +0100
Message-Id: <1213045171.5026.64.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 01:05 +0100, Matthew Garrett wrote:
> Nvidia-based Apple Macbook Pros don't appear to handle backlight control 
> through the graphics card registers or ACPI, but instead trigger changes 
> via SMI calls. This driver registers a generic backlight device that 
> lets existing userspace deal with it. Code derived from Julien Blache's 
> Pommed application.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Queued in the backlight tree, thanks.

Richard

