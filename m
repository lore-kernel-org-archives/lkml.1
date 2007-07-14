Return-Path: <linux-kernel-owner+w=401wt.eu-S1764770AbXGND6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764770AbXGND6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXGND6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:58:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58275 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbXGND6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:58:37 -0400
Date: Fri, 13 Jul 2007 20:54:26 -0700
From: Greg KH <greg@kroah.com>
To: dougthompson@xmission.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 8/8] drivers edac fix edac_device sysfs completion code
Message-ID: <20070714035426.GB11633@kroah.com>
References: <4697ae5a.C7+ELw6Mv5wRCbWz%dougthompson@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4697ae5a.C7+ELw6Mv5wRCbWz%dougthompson@xmission.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 10:54:50AM -0600, dougthompson@xmission.com wrote:
> From:	Douglas Thompson <dougthompson@xmission.com>
> 
> With feedback, this patch corrects operation of the kobject release operation
> on kobjects, attributes and controls for the edac_device.
> 
> CC:             Alan Cox alan@lxorguk.ukuu.org.uk
> Signed-off-by:	Doug Thompson <dougthompson@xmission.com>

Looks good to me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks for making these changes.

greg k-h
