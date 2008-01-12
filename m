Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbYALFVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbYALFVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYALFVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:21:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYALFVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:21:00 -0500
Date: Fri, 11 Jan 2008 21:12:18 -0800
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] attribute_container: update to use the group interface
Message-ID: <20080112051218.GD19894@kroah.com>
References: <1199321327.3258.97.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199321327.3258.97.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 06:48:47PM -0600, James Bottomley wrote:
> This patch is the beginning of moving the attribute_containers to use
> attribute groups exclusively.  The attr element is now deprecated and
> will eventually be removed (along with all the hand rolled code for
> doing exactly what attribute groups do) when all the consumers are
> converted to attribute groups.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

and take it through your tree.

thanks,

greg k-h
