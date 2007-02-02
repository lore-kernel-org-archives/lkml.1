Return-Path: <linux-kernel-owner+w=401wt.eu-S1423060AbXBBN2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423060AbXBBN2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 08:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423058AbXBBN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 08:28:35 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48313 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161131AbXBBN2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 08:28:34 -0500
Message-ID: <45C33C7D.4000203@garzik.org>
Date: Fri, 02 Feb 2007 08:28:29 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2.6.20-rc7 1/2] atl1: get rid of pci_module_init
References: <20070201011052.GA1752@osprey.hogchain.net>
In-Reply-To: <20070201011052.GA1752@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> From: Jay Cliburn <jacliburn@bellsouth.net>
> 
> pci_module_init is deprecated.  Use pci_register_driver instead.
> Discovered by and modification suggested by Alan Cox.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>

applied 1-2 to #atl1


