Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbZGPXPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbZGPXPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933549AbZGPXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:15:21 -0400
Received: from kroah.org ([198.145.64.141]:52491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933536AbZGPXPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:15:20 -0400
Date: Thu, 16 Jul 2009 16:00:42 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream: qdsp support for staging
Message-ID: <20090716230042.GB3609@kroah.com>
References: <20090710083709.GA6418@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710083709.GA6418@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 10:37:10AM +0200, Pavel Machek wrote:
> From: Iliyan Malchev <ibm@android.com>
> 
> QDSP code is neccessarry for communication with some hardware
> components on HTC Dream, including camera hardware. It also drives DSP
> coproccessor.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Please don't compress patches :(

Your patch didn't have any way to actually build the code, care to
respin it and add the proper Kconfig and Makefile hooks?

thanks,

greg k-h
