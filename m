Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXJZL1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXJZL1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXJZL1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:27:07 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:44709 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXJZL1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:27:04 -0400
X-Greylist: delayed 1547 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 07:27:03 EDT
Date: Fri, 26 Oct 2007 13:00:52 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: Upcomming CRIS patches
Message-ID: <20071026110052.GE30833@axis.com>
References: <BFECAF9E178F144FAEF2BF4CE739C668052DE86C@exmail1.se.axis.com> <Pine.LNX.4.64.0710260217260.25424@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710260217260.25424@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 02:20:48AM -0400, Robert P. J. Day wrote:
> just for the sheer heck of it, here's my current list of CRIS-related
> "dead" CONFIG variables you may or may not want to toss before
> committing to the main tree:
> 
> 	$ ../find_dead_configs.sh arch/cris
> [...]

Thanks! We'll clear those up in the process.

> rday

Best regards,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
