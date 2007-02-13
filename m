Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbXBMTCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbXBMTCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXBMTCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:02:54 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:64305 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbXBMTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:02:53 -0500
Date: Tue, 13 Feb 2007 19:02:52 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, vince@arm.linux.org.uk
Subject: Re: [PATCH] mfd: SM501 core driver (#3)
Message-ID: <20070213190252.GB27437@fluff.org.uk>
References: <20070213185542.GA7284@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213185542.GA7284@fluff.org.uk>
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 06:55:42PM +0000, Ben Dooks wrote:
> A new release of the SM501 core mfd driver. 
> 
> This driver provides the core functionality of the
> SM501, which is a multi-function chip including
> two framebuffers, video acceleration, USB, and
> many other peripheral blocks.
> 
> The driver exports a number of entries for the
> peripheral drivers to use.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Vincent Sanders <vince@arm.linux.org.uk>

I would just like to add that I belive that I have
made all the relevant adjustments from the feedback
from the previous two patches. If there is nothing
else from anyone, could this be merged in the current
development window?

We have several successful reports from users of the
previous patches on a variety of architectures
including SH4, PowerPC and ARM.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
