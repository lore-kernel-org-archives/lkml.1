Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZETPUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZETPUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZETPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:20:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:52574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZETPUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:20:41 -0400
Date: Wed, 20 May 2009 08:17:04 -0700
From: Greg KH <gregkh@suse.de>
To: "D. Kelly" <user.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.29.4
Message-ID: <20090520151704.GA25927@suse.de>
References: <20090520053031.GC13453@kroah.com> <5ab239b10905200806h78e2649cy1aa7408fd6653262@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ab239b10905200806h78e2649cy1aa7408fd6653262@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 08:06:51AM -0700, D. Kelly wrote:
> Hi.  I have just updated my kernel from:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.4.tar.bz2
> 
> However, I am getting some errors after I `make menuconfig`:
> 
> exec make kpkg_version=12.013 -f
> /usr/share/kernel-package/ruleset/minimal.mk debian
> DEBIAN_REVISION=Build.1  APPEND_TO_VERSION=.amd64-x2.052009.1
> tail: cannot open `debian/changelog' for reading: No such file or directory
> dpkg-parsechangelog: failure: tail of debian/changelog gave error exit status 1
> 
> 
> I've never had this problem before so was debian/ accidentally left
> out or is it intentionally gone now?

There never has been a "debian/" directory in the kernel.org kernel
releases, has there?

confused,

greg k-h
