Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZKIRp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZKIRp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZKIRpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:45:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:60057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZKIRpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:45:25 -0500
Date: Mon, 9 Nov 2009 09:25:08 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [00/99] 2.6.31.6 stable review
Message-ID: <20091109172508.GA31697@suse.de>
References: <20091106221850.GA15408@kroah.com>
 <200911071943.21503.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911071943.21503.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 07, 2009 at 07:43:21PM +0100, Rafael J. Wysocki wrote:
> On Friday 06 November 2009, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.31.6 release.
> > There are 99 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Responses should be made by November 8, 2009, 20:00:00 UTC.  Anything
> > received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.6-rc1.gz
> > and the diffstat can be found below.
> 
> Please also include commit 9905d1b411946fb3fb228e8c6529fd94afda8a92
> (PM / yenta: Split resume into early and late parts (rev. 4)), which fixes a
> regression present in the previous -stable kernel.

Ok, now added, thanks.

greg k-h
