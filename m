Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYFFEvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYFFEvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYFFEvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:51:44 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4579 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYFFEvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:51:43 -0400
Date: Thu, 5 Jun 2008 22:51:38 -0600
From: Alex Chiang <achiang@hp.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       jbarnes@virtuousgeek.org, Matthew Wilcox <matthew@wil.cx>,
       kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
       pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Export kobject_rename for pci_hotplug_core
Message-ID: <20080606045138.GA28538@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	jbarnes@virtuousgeek.org, Matthew Wilcox <matthew@wil.cx>,
	kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
	pbadari@us.ibm.com, linux-pci@vger.kernel.org,
	pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <20080604201606.GE379@ldl.fc.hp.com> <20080604224838.6b556a51.akpm@linux-foundation.org> <48478247.30809@jp.fujitsu.com> <20080604233348.eb46d8de.akpm@linux-foundation.org> <20080605151140.GA12991@ldl.fc.hp.com> <1212725261.12464.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212725261.12464.4.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> BTW. In the meantime, your current patch set seems fine to go.

That sounds suspiciously like an Acked-by: to me... ;)

> I'll add code to actually do the renumbering of the slot
> separately, along with some other cleanup & rework of the
> pseries PCI hotplug I started doing.

Great, thanks!

/ac

