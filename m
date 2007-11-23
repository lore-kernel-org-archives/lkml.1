Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbXKWRqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbXKWRqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXKWRql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:46:41 -0500
Received: from rtr.ca ([76.10.145.34]:1775 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbXKWRqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:46:40 -0500
Message-ID: <474711FE.8040805@rtr.ca>
Date: Fri, 23 Nov 2007 12:46:38 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca> <4746F02D.2060204@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com>
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morrison, Tom wrote:
> I am hopeful that the sata_mv has this bug (I proved that the
> problem I was experiencing was due to the sata_mv driver 
> with 3.75Gig or more of memory)...
>  
> I am on vacation for a week or more ...or I'd tell you today
> if it did have this bug!
..

Yeah, I kind of had your reports in mind when I asked that.  :)

On a related note, I now have lots of Marvell (sata_mv) hardware here,
and an Intel CPU/chipset box with physical RAM above the 4GB boundary.

Cheers
