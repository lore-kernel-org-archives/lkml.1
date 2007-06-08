Return-Path: <linux-kernel-owner+w=401wt.eu-S937012AbXFHEvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937012AbXFHEvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXFHEvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:51:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40665 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbXFHEvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:51:06 -0400
Date: Thu, 7 Jun 2007 21:38:46 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [-mm patch] make drivers/firmware/dmi-id.c:dmi_id_init() static
Message-ID: <20070608043846.GA28395@kroah.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070603205404.GO5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603205404.GO5500@stusta.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 10:54:04PM +0200, Adrian Bunk wrote:
> This patch makes the needlessly global dmi_id_init() static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks, I've merged this with the original.

greg k-h
