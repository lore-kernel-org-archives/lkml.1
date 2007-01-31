Return-Path: <linux-kernel-owner+w=401wt.eu-S1030538AbXAaVRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030538AbXAaVRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXAaVRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:17:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:51484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030538AbXAaVRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:17:03 -0500
Date: Wed, 31 Jan 2007 13:16:02 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] 20-rc6-mm3: kernel/params.c: compile fail when CONFIG_SYSFS not set
Message-ID: <20070131211602.GD16385@suse.de>
References: <d1v1s29p013gb7etomovojr3l1duh99hca@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1v1s29p013gb7etomovojr3l1duh99hca@4ax.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 07:47:33AM +1100, Grant Coady wrote:
> Hi there,
> 
> This patch is a guess at what's missing, to fix a compile failure when 
> CONFIG_SYSFS not set, going by nearby context.  Please check (or forward 
> to someone) as I'm not sure if this is the right thing to do here.  
> Compile tested.

This looks correct, I'll add it to my patch queue, thanks.

greg k-h
