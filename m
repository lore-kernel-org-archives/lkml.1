Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYCYP0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYCYP0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYCYPZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:25:54 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:41651 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYCYPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Jf+OxcI7Zmb1Pc+4lXrLIHSWmR34D2KnenZmBU5Ab0kQRl6WgTvb9DgCW0PyFXbQzHwt40VDcoSMmgFN2/jTjqJcV/zocPSXoF85r/avMK4bf4iGHtf9AVbzMHa+igcqCYa09Md1gLeN+C1PJSYz7G4vMGM1gyGhNtwJB9WhL+U=
Message-ID: <76366b180803250825s10d706b3ja54df079251d554c@mail.gmail.com>
Date: Tue, 25 Mar 2008 11:25:52 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: ric@emc.com
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Cc: "Mark Lord" <lkml@rtr.ca>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>, "Jeff Garzik" <jgarzik@pobox.com>,
       "Tejun Heo" <htejun@gmail.com>, "Greg KH l" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <47E90CDA.600@emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E875AD.1000901@rtr.ca>
	 <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org>
	 <47E8FF58.8050209@rtr.ca> <47E90CDA.600@emc.com>
X-Google-Sender-Auth: 98d85dfaf425f34c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 10:31 AM, Ric Wheeler <ric@emc.com> wrote:
>  > Yeah.  Except Dell will undoubtedly have them in desktops
>  > within 2 years, and tons of people (myself included) still use
>  > 32-bit (K)Ubuntu on our systems, simply for the better binary
>  > compatibility that it is perceived to give with things like
>  > browser plugins and stuff.
>
>  I think that there are many embedded applications (lots of them linux based)
>  which have large amounts of storage behind low power, low cost 32 bit CPU's.
>
>  Think of the home/small office NAS boxes that you can get from bestbuy or other
>  big box stores. Those devices today have 4 S-ATA drives (each of which can be
>  1TB in size).

I can attest to this. I hear from a reliable source (manufacturer)
that 2TB 3.5" disks will be out no later than first half of 2009
(possibly even sooner, or at least 1.5TB). I currently use 1TB disks
with a Geode LX based motherboard for SATA RAID and I plan on
upgrading/consolidating to larger sizes once they become available in
the market. 64-bit is not an option for me on this hardware.

-Andrew
