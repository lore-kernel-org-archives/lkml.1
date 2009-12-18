Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZLRJEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZLRJEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZLRJEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:04:39 -0500
Received: from smtp27.orange.fr ([80.12.242.95]:62077 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZLRJEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:04:37 -0500
X-ME-UUID: 20091218090242193.2F3A61C006DF@mwinf2706.orange.fr
Subject: Re: No PCI-X / PCI-E cards ...
From: Xavier Bestel <xavier.bestel@free.fr>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <adahbrp43x7.fsf@roland-alpha.cisco.com>
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
	 <adahbrp43x7.fsf@roland-alpha.cisco.com>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 10:02:38 +0100
Message-Id: <1261126958.23135.134.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 14:43 -0800, Roland Dreier wrote:
> > [    0.184098] pci 0000:00:1c.0: BAR 13: can't allocate resource
> 
> When does this message appear?  Does it matter if the PCIe card is
> installed or not?  This 0000:00:1c.0 device is:
> 
> > 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
> 
> so it might be relevant.
> 
> Did you try all the PCIe slots?

No. I'll try that as soon as I can stop it for a while.

BTW, it there any problem putting a PCIe x1 card into a x4 or x16 slot ?

Thanks.

	Xav



