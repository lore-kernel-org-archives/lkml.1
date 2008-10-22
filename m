Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYJVSvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYJVSvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYJVSvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:34718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYJVSvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:33 -0400
Date: Wed, 22 Oct 2008 11:48:08 -0700
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Hiroshi Miura <miura@da-cha.org>,
       YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: Re: [PATCH 01/42] Staging: add pcc-acpi driver
Message-ID: <20081022184808.GA24150@suse.de>
References: <20081022172203.GA4000@kroah.com> <1224696563-5170-1-git-send-email-gregkh@suse.de> <alpine.LFD.1.10.0810221434070.3010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810221434070.3010@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:37:18PM -0400, Len Brown wrote:
> NAK.
> this was already relplaced by the panasonic driver in the acpi tree.

Is this in 2.6.27, or was it a 2.6.28 addition?  For some reason, I had
reports from openSUSE users that 2.6.27 still didn't work properly and
needed this driver.

How about the new "pcc-acpi-cdrom" driver hack?  Hiroshi, is that needed
still with the 2.6.27 kernel?

> Greg,
> If it has the word "acpi" in it, please check with me before
> putting something in the staging tree, for I'd prefer to
> stage such things in the acpi tree.

Ok, I didn't know you wanted "uncleaned" drivers in your tree, I'll
remember this for the future :)

thanks,

greg k-h
