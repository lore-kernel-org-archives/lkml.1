Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYBFToL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYBFToL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbYBFTnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:43:47 -0500
Received: from colo.lackof.org ([198.49.126.79]:53090 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbYBFTnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:43:46 -0500
Date: Wed, 6 Feb 2008 12:43:24 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: uli526x doesn't get link if no link when interface is set up
Message-ID: <20080206194324.GB25918@colo.lackof.org>
References: <20080202145638.GA5871@dis.manty.net> <20080206061507.GA22107@colo.lackof.org> <20080206184447.GA15443@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206184447.GA15443@dis.manty.net>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 07:44:47PM +0100, Santiago Garcia Mantinan wrote:
> > Is this perhaps the same problem as described here?
> >     http://bugzilla.kernel.org/show_bug.cgi?id=5839
> 
> Seems right.
> 
> > If you think it is, could you add (just cut/paste)
> > you email to that bug for me?
> 
> Done

Thanks!

> > Could you also try the patch I attached to that bug report?
> > If it works for you, we can both pester Kyle McMartin to
> > push it upstream. ;)
> 
> Yes, I have tried it and seems to solve the problem for me as well. I'd
> agree to push it.

Excellent. I've asked kyle to push that upstream. He ACKd so it should
go in pretty soon.

thanks again,
grant

> 
> Regards...
> -- 
> Manty/BestiaTester -> http://manty.net
