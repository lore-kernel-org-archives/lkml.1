Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXCVUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXCVUQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 16:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXCVUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 16:16:30 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2704 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbXCVUQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 16:16:29 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 16:16:29 EDT
Date: Thu, 22 Mar 2007 20:51:27 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-ID: <20070322195127.GA69143@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <20070322134230.GP19922@kernel.dk> <20070322143314.GX4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322143314.GX4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 02:33:14PM +0000, Al Viro wrote:
> Correction: current ABI is crap.  To set the thing up you need to open
> it and issue an ioctl.  Which is a bloody bad idea, for obvious reasons...

Agreed.  What would be a right way?  Global device ala ptmx/tun/tap?
New syscall?  Something else?

  OG.
