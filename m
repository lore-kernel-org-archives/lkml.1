Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZF1BZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZF1BZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 21:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZF1BZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 21:25:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1069 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZF1BZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 21:25:17 -0400
Subject: Re: [PATCH 14/19] drivers/scsi: Use PCI_VDEVICE
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Adam Radford <linuxraid@amcc.com>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Rik Faith <faith@cs.unc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>,
       Willem Riede <osst@riede.org>,
       Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
       Matthew Wilcox <matthew@wil.cx>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org,
       osst-users@lists.sourceforge.net
In-Reply-To: <1246136205.3990.70.camel@mulgrave.site>
References: <cover.1245906151.git.joe@perches.com>
	 <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
	 <1246123235.3990.15.camel@mulgrave.site>
	 <1246132405.23023.190.camel@Joe-Laptop.home>
	 <1246136205.3990.70.camel@mulgrave.site>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 18:25:14 -0700
Message-Id: <1246152315.23023.196.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 15:56 -0500, James Bottomley wrote:
> On Sat, 2009-06-27 at 12:53 -0700, Joe Perches wrote:
> > > If that's all it does, I'm having a hard time seeing any actual
> > > improvement here.
> > Greater standardization of declarations across multiple files.
> If this applied to all driver files, I might buy it.

You might note you're looking at patch 14 of 19 and see
that and guess that it has been applied to all driver files.

> is that worth all the code churn?

I think so.

