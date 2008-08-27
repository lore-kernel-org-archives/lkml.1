Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYH0ECB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYH0ECB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 00:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYH0EBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 00:01:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:41297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYH0EBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 00:01:51 -0400
Date: Tue, 26 Aug 2008 21:01:35 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080827040135.GA23547@kroah.com>
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com> <20080823154450.GA27985@kroah.com> <20080823200446.GA24936@ldl.fc.hp.com> <20080825040713.GE3128@kroah.com> <20080827035003.GA25140@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827035003.GA25140@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:50:03PM -0600, Alex Chiang wrote:
> * Greg KH <greg@kroah.com>:
> > And thanks for the other documentation as well, if you want,
> > you could split that out as a different patch and odds are
> > Jesse could get that into the tree before 2.6.27 comes out :)
> 
> Hrm, given the harder line Linus has taken against "regression
> only" patches lately, it can probably wait another release cycle.

Documentation updates and new stand-alone drivers are ok at all times :)

thanks,

greg k-h
