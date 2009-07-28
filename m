Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZG1TTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZG1TTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZG1TTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:19:42 -0400
Received: from kroah.org ([198.145.64.141]:53045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZG1TTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:19:40 -0400
Date: Tue, 28 Jul 2009 12:15:41 -0700
From: Greg KH <greg@kroah.com>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: Thomas Renninger <trenn@suse.de>, stable@kernel.org, rjw@sisk.pl,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [stable] [PATCH] PNPACPI: Enable PNPACPI _PSx Support, v3
Message-ID: <20090728191541.GB25665@kroah.com>
References: <49D101DA.50201@gmx.net>
 <200904021510.37517.trenn@suse.de>
 <20090630230314.GD2634@kroah.com>
 <4A53AAD1.1050308@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A53AAD1.1050308@gmx.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 10:06:41PM +0200, Witold Szczeponik wrote:
> Greg KH wrote:
> 
> [snip]
> 
> > 
> > What specific git commit id in Linus's tree is this?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Hi Greg,
> 
> the git commit id of this patch would be 
> 6328a57401dc5f5cf9931738eb7268fcd8058c49, but the patch triggered a 
> regression which is described in 
> http://bugzilla.kernel.org/show_bug.cgi?id=13243 and which was fixed in 
> 19bde778c1fd2574cc020a618d7d576f260271ca.

Ok, I've queued up both of these for the next .27 stable release.

thanks,

greg k-h
