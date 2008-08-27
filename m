Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYH0DuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYH0DuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 23:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYH0DuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 23:50:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:41736 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYH0DuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 23:50:05 -0400
Date: Tue, 26 Aug 2008 21:50:03 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080827035003.GA25140@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <greg@kroah.com>,
	Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com> <20080823154450.GA27985@kroah.com> <20080823200446.GA24936@ldl.fc.hp.com> <20080825040713.GE3128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825040713.GE3128@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com>:
> On Sat, Aug 23, 2008 at 02:04:46PM -0600, Alex Chiang wrote:
> 
> > Did you get a chance to take a look at the documentation I wrote
> > for these new symlinks? [I also went and documented the existing
> > slots/ directory as well...]
> > 
> > Was it what you had in mind?
> 
> Yes, it looked very good.

Thanks.

> And thanks for the other documentation as well, if you want,
> you could split that out as a different patch and odds are
> Jesse could get that into the tree before 2.6.27 comes out :)

Hrm, given the harder line Linus has taken against "regression
only" patches lately, it can probably wait another release cycle.

After all, it's been un-documented since pre-git history anyway.
;)

Thanks.

/ac

