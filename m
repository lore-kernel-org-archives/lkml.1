Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbXEIOVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbXEIOVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbXEIOVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:21:31 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35339 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXEIOVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:21:30 -0400
Date: Wed, 9 May 2007 07:21:15 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Henry Su <henry.su@amd.com>, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       xiaosuzi520@hotmail.com
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
Message-ID: <20070509142115.GA26646@kroah.com>
References: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com> <4641C066.8080100@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641C066.8080100@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 08:36:54AM -0400, Jeff Garzik wrote:
> Henry Su wrote:
> > From: henry.su@amd.com
> > Adding the device ID for AMD/ATI SB700.
> > Signed-off-by:henry su <henry.su@amd.com>
> 
> Time to train new people...
> 
> You need to split up your patches:
> * send I2C and PCI quirk patches to GregKH

Nope, I2C is not me anymore, I think it's already on it's third
maintainer, check the MAINTAINERS file for details.

thanks,

greg k-h
