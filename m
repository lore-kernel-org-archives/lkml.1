Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179Ab0A3Q2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0A3Q2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 11:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128Ab0A3Q2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 11:28:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:59584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0A3Q2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 11:28:37 -0500
Date: Sat, 30 Jan 2010 08:28:57 -0800
From: Greg KH <gregkh@suse.de>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Samsung N220 backlight support
Message-ID: <20100130162857.GA26029@suse.de>
References: <201001301706.18245.mail@earthworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001301706.18245.mail@earthworm.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 05:06:18PM +0100, Christian Hesse wrote:
> Hello Greg,
> 
> this adds support for Samsung N220 to your samsung-backlight. Tested on my 
> device, works for me.

Hm, the driver that ended up in the kernel is very different from this
version.  Can you work with that version and add the needed changes
there and generate a patch?

thanks,

greg k-h
