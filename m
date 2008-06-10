Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYFJVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYFJVZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYFJVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:25:23 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1361 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbYFJVZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:25:22 -0400
Date: Tue, 10 Jun 2008 15:25:20 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, greg@kroah.com
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       lenb@kernel.org, pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3, v16] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080610212520.GJ25295@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, greg@kroah.com,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, lenb@kernel.org, pbadari@us.ibm.com,
	linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Jesse,

This is v16 of the physical PCI slot series.

It is based off of Jesse's linux-next branch in his PCI tree.

Greg, Jesse, there might be an issue with
372fa8fa0a77c47c7bcfae0ccd14e0c5f97d17fe, which is in Stephen
Rothwell's linux-next tree, but not in Jesse's. The correct fix
would be for Greg to entirely drop the hunk that touches
drivers/pci/hotplug/fakephp.c.

Jesse said he'd like to see final ACKs from Kenji-san and
Kristen, and then we'll be good to go for 2.6.27.

Thanks,

/ac

