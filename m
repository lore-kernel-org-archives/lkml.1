Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXGaW2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXGaW2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbXGaW16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:27:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbXGaW15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:27:57 -0400
Subject: RE: regression on HP zx1 platform from ACPI autoload modulespatches
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Doug Chapman <doug.chapman@hp.com>, Tony Luck <tony.luck@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <617E1C2C70743745A92448908E030B2A020E3B4F@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A020E3B4F@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 01 Aug 2007 00:27:53 +0200
Message-Id: <1185920873.18821.268.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 09:54 -0700, Luck, Tony wrote:
> > Tony, it looks like the patch has not hit Linus tree yet:
> 
> 
> Huh?  I can see it in his tree via gitweb.  Here's the patch:
> 
> 	http://tinyurl.com/3csnu6
> 
> and the raw "blob" for sba_iommu.c:
> 
> 	http://tinyurl.com/397cy6
> 
> [Scroll down to line 2018 and you'll see the new code in place].
> 
> Something very odd is happening.
My fault. A clean new checkout of the tree has the patch included.
Sorry for the confusion,

   Thomas

