Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbYALBdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbYALBdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762559AbYALBcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:32:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60526 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760923AbYALBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:32:50 -0500
Date: Fri, 11 Jan 2008 17:32:24 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH -mm 1/4] genhd: fixup kobj_to_dev() macro
Message-ID: <20080112013224.GA4778@kroah.com>
References: <20080108084304.GA6209@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108084304.GA6209@localhost.sw.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 11:43:04AM +0300, Alexey Dobriyan wrote:
> Please, fold into gregkh-driver-block-device.patch
> -------------------------------------------------------
> [PATCH -mm 1/4] genhd: fixup kobj_to_dev() macro

Thanks, I've now merged it in.

greg k-h
