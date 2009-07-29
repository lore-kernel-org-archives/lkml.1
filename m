Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZG2IxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZG2IxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZG2IxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:53:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16778 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZG2IxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:53:04 -0400
Date: Wed, 29 Jul 2009 11:52:29 +0300
From: "Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] vga: drops a documentation regarding the VGA
	arbiter
Message-ID: <20090729085229.GA27252@tubao.research.nokia.com>
Reply-To: tiago.vignatti@nokia.com
References: <1247759311-6254-1-git-send-email-tiago.vignatti@nokia.com> <1247759311-6254-2-git-send-email-tiago.vignatti@nokia.com> <1247759311-6254-3-git-send-email-tiago.vignatti@nokia.com> <200907281325.51077.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907281325.51077.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 29 Jul 2009 08:52:28.0278 (UTC) FILETIME=[E6A55960:01CA1029]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:25:50PM +0200, Bjorn Helgaas wrote:
> On Thursday 16 July 2009 09:48:30 am Tiago Vignatti wrote:
> > Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> > ---
> >  Documentation/vgaarbiter.txt |  197 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 197 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/vgaarbiter.txt
> 
> I think the documentation update should be part of the same patch
> that adds the functionality.  Then the docs will always match
> the code.

I don't think some "normal" kernel developer will need such document.

Looks like we're doing nice cuts (well, Dave is) on this patch and coming in a
state that people won't need to understand in deep things related with VGA
arbiter before doing hacks with DRM/PCI drivers. Moreover, the vgaarb.h is
pretty well readable :)


Cheers, 
            Tiago
