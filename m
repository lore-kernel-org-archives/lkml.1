Return-Path: <linux-kernel-owner+w=401wt.eu-S934668AbXFGSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668AbXFGSvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761062AbXFGSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:51:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794AbXFGSvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:51:14 -0400
Date: Thu, 7 Jun 2007 14:48:05 -0400
From: Bill Nottingham <notting@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Jones <pjones@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607184805.GA28551@nostromo.devel.redhat.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Jones <pjones@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	linux-kernel@vger.kernel.org
References: <4667C47C.2010207@googlemail.com> <1181206091.3625.9.camel@lov.localdomain> <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain> <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de> <20070607085200.f8d6e2d3.akpm@linux-foundation.org> <20070607155953.GA17591@suse.de> <20070607090632.cfcf02e6.akpm@linux-foundation.org> <20070607161525.GA18363@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607161525.GA18363@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH (gregkh@suse.de) said: 
> There are a number of distros out there right now who can support that
> option disabled.  I'm pretty sure they are the following right now:
> 	Gentoo unstable (actually stable works now for me, but I'm not
> 			 going to guarantee it just yet...)
> 	Debian unstable (again stable might work, but I have not heard
> 			 any reports from testers.)
> 	openSUSE FACTORY (the 10.3 alpha releases)
> 
> and now it sounds like Red Hat rawhide will also work properly.

I suspect while it will work for mkinitrd, the installer will not
work properly.

Bill
