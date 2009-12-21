Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbZLUQqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbZLUQqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZLUQqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:46:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbZLUQqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:46:46 -0500
Date: Mon, 21 Dec 2009 08:46:19 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] Driver core: export platform_device_register_data as a
 GPL symbol
Message-ID: <20091221164619.GA27521@suse.de>
References: <1261413668-30145-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261413668-30145-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:41:08AM -0500, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> This allows MFD's to register/bind drivers for their sub devices while
> still being compiled as a module.

Is this a problem that we need to get resolved in .33, or older kernels,
or just for .34?

thanks,

greg k-h
