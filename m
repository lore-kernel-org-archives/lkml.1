Return-Path: <linux-kernel-owner+w=401wt.eu-S934658AbYBNV1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658AbYBNV1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934559AbYBNV1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:27:17 -0500
Received: from mail.suse.de ([195.135.220.2]:41761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934607AbYBNV1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:27:15 -0500
Date: Thu, 14 Feb 2008 13:25:13 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Lloyd <klloyd@sierrawireless.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: move zte MF330 from sierra to option
Message-ID: <20080214212513.GA18441@suse.de>
References: <47B0B02D.2000906@sierrawireless.com> <20080214131228.f76848bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214131228.f76848bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:12:28PM -0800, Andrew Morton wrote:
> On Mon, 11 Feb 2008 12:29:33 -0800
> Kevin Lloyd <klloyd@sierrawireless.com> wrote:
> 
> > From: Kevin Lloyd <linux@sierrawireless.com>
> > 
> > Moves the Onda H600/ZTE MF33 device from the sierra driver to the option driver.
> > 
> 
> A changelog should describe why a change was made, not simply what the
> change is.

I know the history behind it, I'll flush it out when I add it to my
tree.  Kevin sent this patch because I asked for it, so I'll take the
blame here.

thanks,

greg k-h
