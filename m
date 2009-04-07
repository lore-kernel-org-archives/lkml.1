Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbZDGWop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbZDGWop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbZDGWoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:44:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZDGWob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:44:31 -0400
Date: Tue, 7 Apr 2009 15:41:22 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090407224122.GG11258@suse.de>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151232.GA21657@srcf.ucam.org> <20090403155704.GA26189@suse.de> <20090403160639.GA22722@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403160639.GA22722@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 05:06:39PM +0100, Matthew Garrett wrote:
> On Fri, Apr 03, 2009 at 08:57:04AM -0700, Greg KH wrote:
> > On Fri, Apr 03, 2009 at 04:12:32PM +0100, Matthew Garrett wrote:
> > > Hmm. What's the USB ID of that one?
> > 
> > USB_DEVICE(0x05c6, 0x9211);
> 
> The driver seems to flag that as the QDL device rather than the modem. 
> Are you sure it's working?

No I'm not as the whole laptop seems to be dead now, so I can't verify
it :(

stupid pre-production hardware...

sorry,

greg k-h
