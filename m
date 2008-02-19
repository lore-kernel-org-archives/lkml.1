Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYBSTkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYBSTkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYBSTjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:39:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48473 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYBSTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:39:50 -0500
Date: Tue, 19 Feb 2008 11:32:50 -0800
From: Greg KH <greg@kroah.com>
To: Scott Murray <scottm@somanetworks.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 06/12] PCI Hotplug: make cpcihp driver
	use modern apis
Message-ID: <20080219193250.GB5088@kroah.com>
References: <20080215003909.GA27981@kroah.com> <1203036010-27988-6-git-send-email-gregkh@suse.de> <alpine.LFD.0.9999.0802151744330.3386@rancor.yyz.somanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0802151744330.3386@rancor.yyz.somanetworks.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 05:45:47PM -0500, Scott Murray wrote:
> On Thu, 14 Feb 2008, Greg Kroah-Hartman wrote:
> 
> > This removes the depandancy of the cpcihp driver from the PCI_LEGACY
> > config option by removing its usage of the pci_find_bus() function.
> >
> >
> > Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > Cc: Scott Murray <scottm@somanetworks.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Sorry for the slow reply, this looks fine to me.
> 
> Signed-off-by: Scott Murray <scottm@somanetworks.com>

Great, thanks for reviewing it.

greg k-h
