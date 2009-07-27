Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZG0Wtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZG0Wtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZG0Wtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:49:33 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59443 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbZG0Wtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:49:32 -0400
X-Sasl-enc: +/Mvfj+WfAsmxqGXLRt001Q4drpUCKXLO6TIST0xFJzK 1248734966
Date: Mon, 27 Jul 2009 19:49:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: Re: [PATCH] documentation: make it clear that sysfs is optional
Message-ID: <20090727224930.GB6932@khazad-dum.debian.net>
References: <20090727090642.0e495919.randy.dunlap@oracle.com>
 <20090727161031.GA15328@suse.de>
 <20090727091824.38d55ea1.randy.dunlap@oracle.com>
 <20090727162601.GA3632@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727162601.GA3632@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Greg KH wrote:
> On Mon, Jul 27, 2009 at 09:18:24AM -0700, Randy Dunlap wrote:
> > On Mon, 27 Jul 2009 09:10:33 -0700 Greg KH wrote:
> > > On Mon, Jul 27, 2009 at 09:06:42AM -0700, Randy Dunlap wrote:
> > > > The original text suggested that sysfs is mandatory and always
> > > > compiled in the kernel.
> > > 
> > > But it should be :)
> > 
> > Well, you have the option of making it non-optional.
> > 
> > > Seriously, who turns sysfs off these days, does anyone?  If so, why?
> > 
> > Why is it configurable then?
> 
> Probably the same reason /proc is configurable.  No one ever turns it
> off, but hey, it's possible :)

But does anyone ever test if the system doesn't go to lunch when you do
that?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
