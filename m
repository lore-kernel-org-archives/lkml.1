Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbXKTMV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbXKTMV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXKTMVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:21:18 -0500
Received: from nic2.axis.se ([193.13.178.10]:59098 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbXKTMVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:21:17 -0500
Date: Tue, 20 Nov 2007 13:21:07 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jan Dittmer <jdi@l4x.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cris build fixes
Message-ID: <20071120122107.GA14797@axis.com>
References: <47414764.1020501@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47414764.1020501@l4x.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 09:20:52AM +0100, Jan Dittmer wrote:
> Hi,
> 
> I saw that you merged a lot of cris bug fixes into 2.6.24-rc3.
> Is the cris arch supposed to build again now? If yes which binutils
> and gcc version is needed? I'm getting the following error [1]:

Yep, unfortunately, it does not build right out of the box due
to some problem with the architecture links.

Issuing a second "make" command will work, allowing the compile to continue.

I'm looking at ways to fix this, but I need to be minimal in my
changes to avoid causing problems for our internal development.

Best regards,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
