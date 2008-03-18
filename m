Return-Path: <linux-kernel-owner+w=401wt.eu-S938989AbYCSVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938989AbYCSVv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYCSUUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:20:08 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48742 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbYCSUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:20:05 -0400
Date: Tue, 18 Mar 2008 14:49:13 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080318204913.GA18797@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com> <20080311110403.7db9527c@appleyard> <20080311191406.GB29344@ldl.fc.hp.com> <47D7BF6C.3080306@jp.fujitsu.com> <20080313032410.GA17561@ldl.fc.hp.com> <20080314021646.GC6145@us.ibm.com> <47DA0E77.9010706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA0E77.9010706@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

> Ok, I understood what you mean and I agreed both implementations
> are legal. Also I explained it to our firmware team, and they
> understood your situation.

Great, thanks.

> I don't know which implementation is more popular. But according
> to the current score (2 : 1), you win the "majority rule".

Yep, and when we get more testing, if it turns out that more
vendors follow the Fujitsu interpretation, then we can change the
default behavior.

> Alex-san, could you send me the updated patches? I'll Ack the
> patch after adding Fujitsu firmware versions to the DMI list
> and testing it.

Yes, I'll send out a new patch series today that also fixes the
shpchp/pciehp naming issue.

Thanks.

/ac

