Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbZAOVPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbZAOVPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZAOVPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:15:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:33531 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbZAOVPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:15:19 -0500
Date: Thu, 15 Jan 2009 13:12:34 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: Re: [patch 00/94] 2.6.28.1 stable review
Message-ID: <20090115211234.GA28143@suse.de>
References: <20090115195520.GA14403@kroah.com> <200901152200.04272.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901152200.04272.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 09:59:59PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On thursday january 15th, 2009 Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.28.1 release.
> > There are 94 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> 
> Please consider adding the following patch, referring to
> http://bugzilla.kernel.org/show_bug.cgi?id=12301
> 
> commit 2caf7fcdb8532045680f06b67b9e63f0c9613aaa
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Wed Dec 31 11:31:33 2008 -0500

<snip>

Alan said he would provide a backported version of this patch for .28
after it went into Linus's tree, as this version will not apply
properly.

Alan, care to come up with something?

thanks,

greg k-h
