Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXDMDR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXDMDR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 23:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXDMDR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 23:17:57 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:52170 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXDMDR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 23:17:56 -0400
Date: Thu, 12 Apr 2007 23:16:15 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070413031615.GA21061@athena.road.mcmartin.ca>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070323112411.f6a8a762.randy.dunlap@oracle.com> <20070323200819.4e734f4f@lxorguk.ukuu.org.uk> <20070323130315.7ed48121.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323130315.7ed48121.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 01:03:15PM -0700, Randy Dunlap wrote:
> > It's 0x40. Its a "command dependant bit" - no useful name.
> 
> dependent.  OK, thanks.
> 

Hi,

Pondering about this, it's ATA_LBA according to the docs, specifying
that the address is an LBA.

Cheers,
	Kyle
