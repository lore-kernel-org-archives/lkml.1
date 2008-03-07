Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbYCGTve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbYCGTve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759918AbYCGTv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:51:26 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:36413 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759676AbYCGTvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:51:25 -0500
Date: Fri, 7 Mar 2008 20:51:08 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: David Brownell <david-b@pacbell.net>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <alpine.DEB.1.00.0803052357400.8658@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803072047590.7723@sheep.housecafe.de>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org> <200803041630.11832.david-b@pacbell.net> <alpine.DEB.1.00.0803050215140.7069@sheep.housecafe.de> <200803042025.30613.david-b@pacbell.net>
 <alpine.DEB.1.00.0803052357400.8658@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Christian Kujau wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:
>> Nah.  See the patch I just attached to
>> 	http://bugzilla.kernel.org/show_bug.cgi?id=10078
>
> Thanks, I'm compiling (applied to -rc4 with some fuzz, hope that's ok) now 
> and will test tomorrow.

For the record: the WARNINGS are gone and USB is still functional. I'm 
having other (much more severe) problems with -rc4 now, but they seem 
unrelated to your patch.

Thanks,
Christian.
-- 
BOFH excuse #317:

Internet exceeded Luser level, please wait until a luser logs off before attempting to log back on.
