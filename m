Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752704AbYLQX5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYLQX5T (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYLQX5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:57:08 -0500
Received: from mail.suse.de ([195.135.220.2]:36331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYLQX5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:57:07 -0500
Date: Wed, 17 Dec 2008 15:45:25 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCH 2/4] xilinx_hwicap: remove improper wording in license
	statement
Message-ID: <20081217234525.GA16661@suse.de>
References: <20081217192737.GA24641@kroah.com> <1229542103-24678-2-git-send-email-gregkh@suse.de> <20081217230855.29a26318@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217230855.29a26318@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 11:08:55PM +0000, Alan Cox wrote:
> On Wed, 17 Dec 2008 11:28:21 -0800
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > GPLv2 doesn't allow additional restrictions to be imposed on any
> > code, so this wording needs to be removed from these files.
> 
> You only need to remove the "Use in .. expressly prohibited bit", the
> rest seems like useful relevant information.

As this ended up just being boiler-plate wording from an internal Xilinx
template, and didn't apply at all to these files, it seemed easier to
just remove the whole thing :)

thanks,

greg k-h
