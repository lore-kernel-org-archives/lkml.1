Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbXF3DJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbXF3DJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXF3DJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:09:00 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:57692 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbXF3DI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:08:59 -0400
Date: Sat, 30 Jun 2007 06:08:54 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630030854.GA1297@localdomain>
References: <20070630023451.GA21593@localdomain> <E1I4TDU-00023A-Nc@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I4TDU-00023A-Nc@flower>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 05:01:44AM +0200, Oleg Verych wrote:
> * Date: Sat, 30 Jun 2007 05:34:51 +0300
> >
> > Hello,
> >
> > I'd like to present a suggestion for automatic generation of 
> > carbon copy fields in the E-Mails of posted patches.
> >
> > Basically, instead of manually figuring out who to add to CC
> > when sending a patch to LKML by looking at MAINTAINERS, a 
> > script can look at '.maintainers' files spread across the
> > source tree and automatically generate a proper list of CCs
> > for a patch.
> 
> LKML archive near you, search phrase "BTS", subjects that have
> something about "the quality of the kernel". Good luck. 

Right, however many patches don't map to bug reports and don't 
need the heavy use of BTS. This suggestion is mainly for the 
improvement of peer review concerning code changes submitted 
by people who are not the maintainers.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
