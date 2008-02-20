Return-Path: <linux-kernel-owner+w=401wt.eu-S1763679AbYBTGdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763679AbYBTGdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYBTGd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:33:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37985 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYBTGdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:33:25 -0500
Date: Tue, 19 Feb 2008 22:38:34 -0800
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <20080220063834.GA22708@kroah.com>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 09:52:25PM +0100, Guennadi Liakhovetski wrote:
> Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
> getting the following warnings (with a bit of context):

Can you try enabling CONFIG_DEBUG_KOBJECT and sending the output at boot
time from this?

thanks,

greg k-h
