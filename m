Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZCXXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZCXXvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZCXXvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:51:03 -0400
Received: from kroah.org ([198.145.64.141]:38367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753802AbZCXXvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:51:01 -0400
Date: Tue, 24 Mar 2009 16:14:48 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: david@lang.hm, Dan Williams <dcbw@redhat.com>,
       Patrick McHardy <kaber@trash.net>, Matt Domsch <Matt_Domsch@dell.com>,
       netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
Message-ID: <20090324231448.GA21479@kroah.com>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com> <49C9087C.5070907@trash.net> <1237912858.9082.39.camel@localhost.localdomain> <alpine.DEB.1.10.0903241150020.16753@asgard.lang.hm> <20090324210214.7ae65c06@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324210214.7ae65c06@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 09:02:14PM +0000, Alan Cox wrote:
> > this is convienient for some things, but not for others.
> > 
> > what's unique and reproducable is the discovery order
> 
> Not in the case of things like USB...

Or even PCI.

/me pats his laptop that reassigns PCI device ids randomly every 3rd or so boot.
