Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbXHCVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbXHCVRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761792AbXHCVRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:17:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2429 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761732AbXHCVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:17:29 -0400
Date: Fri, 3 Aug 2007 17:17:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Jones <davej@redhat.com>
cc: Greg KH <gregkh@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default
 on certain device classes
In-Reply-To: <20070803201239.GB20376@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0708031716030.5099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Dave Jones wrote:

> here's a head start for you.
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243038
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246713
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243953
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242359
> 
> That's just the ones that were handy..

The last report appears to be related more to the EHCI-cpufreq problem, 
for which a patch was recently posted.

Alan Stern

