Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXAaMvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXAaMvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933208AbXAaMvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:51:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56541 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbXAaMvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:51:43 -0500
Message-ID: <45C090D2.4060302@garzik.org>
Date: Wed, 31 Jan 2007 07:51:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Divy Le Ray <None@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com
Subject: Re: [PATCH 1/10] cxgb3 - FW versioning
References: <20070131034345.8574.21031.stgit@localhost.localdomain> <45C07202.3090308@garzik.org> <20070131124437.GA26476@infradead.org>
In-Reply-To: <20070131124437.GA26476@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jan 31, 2007 at 05:40:02AM -0500, Jeff Garzik wrote:
>> honestly it looks like just about every ioctl except load-firmware should go
> 
> And while we're at it a load-firmware sounds like a nice addition for
> ethtool aswell.  Or we may want to extent the firmware loader to deal with
> updating firmware in addition to loading it to rom-less devices.

Agreed.

	Jeff



