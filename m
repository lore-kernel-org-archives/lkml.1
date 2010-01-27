Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444Ab0A0QhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0A0QhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113Ab0A0QhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:37:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:59322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab0A0Qg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:36:59 -0500
Date: Wed, 27 Jan 2010 08:35:49 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Rosenstand <rosenstand@gmail.com>
Subject: Re: [12/98] Driver-Core: devtmpfs - set root directory mode to 0755
Message-ID: <20100127163549.GA22128@suse.de>
References: <20100126233950.GA5372@kroah.com>
 <20100126233922.430096741@mini.kroah.org>
 <ac3eb2511001262009o2bacb51n1acbaf64a526c0dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2511001262009o2bacb51n1acbaf64a526c0dc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 05:09:23AM +0100, Kay Sievers wrote:
> On Wed, Jan 27, 2010 at 00:33, Greg KH <gregkh@suse.de> wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Kay Sievers <kay.sievers@vrfy.org>
> >
> > commit 03d673e6af6490371aaf64dfe1f84c658c48b71d upstream.
> 
> Hey Greg,
> to silent a warning this change causes, this might also be good to have:
>   vfs: get_sb_single() - do not pass options twice
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9329d1beaeed1a94f030c784dcec5ff973f402c4

You are right, thanks for pointing that out, I've queued it up as well.

thanks,

greg k-h
