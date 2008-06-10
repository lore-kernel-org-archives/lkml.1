Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYFJVki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYFJVki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYFJVka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:40:30 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:48612 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755854AbYFJVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:40:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 0/3, v16] PCI, ACPI: Physical PCI slot objects
Date: Tue, 10 Jun 2008 14:39:50 -0700
User-Agent: KMail/1.9.9
Cc: greg@kroah.com, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       lenb@kernel.org, pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080610212520.GJ25295@ldl.fc.hp.com>
In-Reply-To: <20080610212520.GJ25295@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101439.51174.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2008 2:25 pm Alex Chiang wrote:
> Hi Greg, Jesse,
>
> This is v16 of the physical PCI slot series.
>
> It is based off of Jesse's linux-next branch in his PCI tree.
>
> Greg, Jesse, there might be an issue with
> 372fa8fa0a77c47c7bcfae0ccd14e0c5f97d17fe, which is in Stephen
> Rothwell's linux-next tree, but not in Jesse's. The correct fix
> would be for Greg to entirely drop the hunk that touches
> drivers/pci/hotplug/fakephp.c.
>
> Jesse said he'd like to see final ACKs from Kenji-san and
> Kristen, and then we'll be good to go for 2.6.27.

Ok, pushed these to my linux-next tree.  As usual, testing & more review 
appreciated.

Thanks,
Jesse
