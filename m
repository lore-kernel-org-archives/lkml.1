Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0CIVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:15:22 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34253 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0CIVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:15:03 -0500
Date: Tue, 9 Mar 2010 21:14:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: Joey Lee <jlee@novell.com>, mzxreary@0pointer.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that is
	need load SCM
Message-ID: <20100309211459.GA4390@srcf.ucam.org>
References: <4B96DD0202000023000146D6@novprvlin0050.provo.novell.com> <20100309210150.GC32299@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309210150.GC32299@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 01:01:50PM -0800, Greg KH wrote:
> On Tue, Mar 09, 2010 at 05:42:58AM -0700, Joey Lee wrote:
> > Hi Greg, 
> > 
> > Please kindly review the attached patch for removed the non-standard
> > interface "threeg" in msi-laptop driver.
> 
> Looks good to me.
> 
> Matthew, are you going to be taking patches like this now?

I am.

> If so, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch.

Will do.

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
