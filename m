Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbYBGHjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbYBGHjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYBGHjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:39:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbYBGHjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:39:31 -0500
Date: Wed, 6 Feb 2008 23:43:39 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207074339.GA25194@suse.de>
References: <20080207070044.GA4851@suse.de> <20080206.231144.174648341.davem@davemloft.net> <20080207071807.GA13866@suse.de> <20080206.233339.74740365.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.233339.74740365.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:33:39PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 23:18:07 -0800
> 
> > How about this attempt?
> 
> That works, thanks.  Please push to Linus :-)
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Great, thanks for testing, I'll send it to him tomorrow.

greg k-h
