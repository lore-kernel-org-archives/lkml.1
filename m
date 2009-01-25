Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZAYTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZAYTCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 14:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZAYTCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 14:02:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbZAYTCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 14:02:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
Date: Sun, 25 Jan 2009 20:01:23 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <200901240019.36794.rjw@sisk.pl> <20090125052947.GB22539@colo.lackof.org> <20090125053545.GC22539@colo.lackof.org>
In-Reply-To: <20090125053545.GC22539@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901252001.24811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 January 2009, Grant Grundler wrote:
> On Sat, Jan 24, 2009 at 10:29:47PM -0700, Grant Grundler wrote:
> > Is this intended to be used by drivers?
> 
> The answer depends on if "PCI Express port driver" can be loaded
> as a module.

No, it's not, AFAICS.

Thanks,
Rafael
