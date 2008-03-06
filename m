Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbYCFCKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbYCFCKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933953AbYCFCJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:09:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45138 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbYCFCJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:09:48 -0500
Message-ID: <47CF51F6.5030702@jp.fujitsu.com>
Date: Thu, 06 Mar 2008 11:07:50 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com>
In-Reply-To: <20080305202052.GN3694@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

> So given that it's two versus one, I modified my
> drivers/acpi/pci_slot module to consider Fujitsu machines to be a
> quirk. :)
> 
> Can you please test patches 1 and 2 that I sent out as v8 of my
> series, but replace patch 3 with this patch?

I don't have any better idea than this so far.
I'll try suggested patch and send feedback as soon as possible.

Thanks,
Kenji Kaneshige


