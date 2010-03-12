Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab0CLR17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:27:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34211 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab0CLR16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:27:58 -0500
Date: Fri, 12 Mar 2010 17:27:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: provide sysfs percent brightness attribute
Message-ID: <20100312172755.GA13891@srcf.ucam.org>
References: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 11:10:35AM -0600, H Hartley Sweeten wrote:
> It's usually more convenient to set the backlight brightness
> as a 'percent' of total brightness rather than using the raw
> 'brightness' value.
> 
> This provides the necessary sysfs attributes to handle this.

Why not just do this in the app?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
