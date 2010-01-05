Return-Path: <linux-kernel-owner+w=401wt.eu-S932111Ab0AETFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0AETFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083Ab0AETFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:05:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0AETFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:05:41 -0500
Date: Tue, 5 Jan 2010 10:56:27 -0800
From: Greg KH <gregkh@suse.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [00/97] 2.6.32.3 stable review
Message-ID: <20100105185627.GA15630@suse.de>
References: <20100105003133.GA7199@kroah.com>
 <43e72e891001041655r261dd087yfcd50883c618185b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e72e891001041655r261dd087yfcd50883c618185b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 04:55:42PM -0800, Luis R. Rodriguez wrote:
> On Mon, Jan 4, 2010 at 4:31 PM, Greg KH <gregkh@suse.de> wrote:
> > This is the start of the stable review cycle for the 2.6.32.3 release.
> > There are 97 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> >
> > Responses should be made by Thursday, Jan 7, 00:00:00 UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.3-rc1.gz
> > and the diffstat can be found below.
> >
> >
> > thanks,
> 
> Wireless stuff looks good, except I'd prefer if we'd get the EEPROM
> fix for ath5k merged in there as well but I realize a respective
> upstream sha1sum is not yet available, but say we get it before
> Friday, is it OK to queue it in? The patch in question is:
> 
> http://marc.info/?l=linux-wireless&m=126261964315049&w=2

No, how about we wait for the next .32-stable release, as we need to
have the patches in Linus's tree first.

It's not like .32 isn't going to have a lot of releases over its
lifespan, it is going to be around for a long time :)

Patience,

greg k-h
