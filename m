Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZIKPeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZIKPeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZIKPeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:34:10 -0400
Received: from kroah.org ([198.145.64.141]:57382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZIKPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:34:09 -0400
Date: Fri, 11 Sep 2009 08:31:29 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/22] 2.6.30.7-stable review
Message-ID: <20090911153129.GA17127@kroah.com>
References: <20090911002616.GA12087@kroah.com>
 <20090911051939.GE23210@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911051939.GE23210@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 10:19:39PM -0700, Dmitry Torokhov wrote:
> On Thu, Sep 10, 2009 at 05:26:16PM -0700, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.30.7 release.
> > There are 22 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> 
> Please consider adding the following commit to the stable:
> 
> 	ec8b4b7085605e801a7740a2c3c33256aebe249c

I will queue it up for the next release.

thanks,

greg k-h
