Return-Path: <linux-kernel-owner+w=401wt.eu-S1751028AbXBQUSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbXBQUSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbXBQUSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:18:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47644 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXBQUSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:18:23 -0500
Message-ID: <45D7630A.4040502@garzik.org>
Date: Sat, 17 Feb 2007 15:18:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, crsprouse@gmail.com
Subject: Re: [PATCH 1/6] atl1: drop NET_PCI from Kconfig
References: <20070215021213.GB9753@osprey.hogchain.net>
In-Reply-To: <20070215021213.GB9753@osprey.hogchain.net>
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
> The atl1 driver doesn't need NET_PCI.  Remove it from Kconfig.
> Noticed by Chad Sprouse.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> Signed-off-by: Chris Snook <csnook@redhat.com>

applied 1-6


