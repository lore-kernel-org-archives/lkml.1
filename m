Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYH0OVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYH0OVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYH0OVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:21:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49531 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYH0OVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:21:45 -0400
Date: Wed, 27 Aug 2008 08:21:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in /sys/bus/pci/slots/N/
Message-ID: <20080827142139.GB19788@parisc-linux.org>
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com> <20080823154450.GA27985@kroah.com> <20080823200446.GA24936@ldl.fc.hp.com> <20080825040713.GE3128@kroah.com> <20080827035003.GA25140@ldl.fc.hp.com> <20080827040135.GA23547@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827040135.GA23547@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:01:35PM -0700, Greg KH wrote:
> On Tue, Aug 26, 2008 at 09:50:03PM -0600, Alex Chiang wrote:
> > * Greg KH <greg@kroah.com>:
> > > And thanks for the other documentation as well, if you want,
> > > you could split that out as a different patch and odds are
> > > Jesse could get that into the tree before 2.6.27 comes out :)
> > 
> > Hrm, given the harder line Linus has taken against "regression
> > only" patches lately, it can probably wait another release cycle.
> 
> Documentation updates and new stand-alone drivers are ok at all times :)

You're clearly not hanging on every word of our Dear Leader:

http://marc.info/?l=linux-kernel&m=121924636529367&w=2

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
