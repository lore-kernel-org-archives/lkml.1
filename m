Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbZHJQbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbZHJQbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbZHJQbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:31:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:36812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbZHJQbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:31:40 -0400
Date: Mon, 10 Aug 2009 09:30:05 -0700
From: Greg KH <gregkh@suse.de>
To: "Emilio G. Cota" <cota@braap.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Martyn Welch <martyn.welch@gefanuc.com>,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090810163005.GC27912@suse.de>
References: <20090803205657.964064732@mini.kroah.org>
 <20090803210111.GB28430@kroah.com>
 <20090808230145.GB27151@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808230145.GB27151@braap.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 01:01:45AM +0200, Emilio G. Cota wrote:
> A few comments after a quick glance, will need to dig deeper
> though:
> - semaphores? isn't it screaming for mutexes?

Probably, it's old code forward-ported.  Patches gladly welcome.

thanks,

greg k-h
