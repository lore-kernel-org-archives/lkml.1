Return-Path: <linux-kernel-owner+w=401wt.eu-S934676AbZDCPQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbZDCPQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934478AbZDCPPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:15:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42056 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934517AbZDCPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:15:39 -0400
Date: Fri, 3 Apr 2009 16:15:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403151531.GB21657@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403151237.GA25994@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 08:12:37AM -0700, Greg KH wrote:
> On Fri, Apr 03, 2009 at 08:03:01AM -0700, Greg KH wrote:
> > > I thought we'd decided that drivers weren't going to be merged in that
> > > case (poulsbow, the original 3945 driver)
> > 
> > We have lots of drivers that rely on firmware that is not in the kernel
> > to work properly, I see this as just the same thing.
> > 
> > And again, I have been assured that the code is going to be distributed
> > soon, and that others are already using the driver successfully.
> 
> Hm, look at the linux-usb list, someone has posted a shell script that
> gets the hardware to work properly already.

Ah, now that is progress. Thanks!
-- 
Matthew Garrett | mjg59@srcf.ucam.org
