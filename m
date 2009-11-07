Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZKGWq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZKGWq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZKGWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:46:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbZKGWq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:46:57 -0500
From: Thomas Renninger <trenn@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
Date: Sat, 7 Nov 2009 23:47:04 +0100
User-Agent: KMail/1.9.10
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@gmail.com,
       Matthew Garrett <mjg@redhat.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Amod Bodas <Amod.Bodas@atheros.com>,
       David Quan <David.Quan@atheros.com>,
       Kishore Jotwani <Kishore.Jotwani@atheros.com>
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> <200911072152.57596.trenn@suse.de> <4AF5F47C.5000402@linux.intel.com>
In-Reply-To: <4AF5F47C.5000402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911072347.05786.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009 11:28:12 pm Arjan van de Ven wrote:
> Thomas Renninger wrote:
>
> > On Friday 06 November 2009 09:01:00 pm Luis R. Rodriguez wrote:
> >> With cpu frequency scaling you may run into some system
> >> performance issues when the FSB changes speed due to the
> >> throughput constraints this brings on the system.
> >
> > Interesting.
> > Could you be a bit more detailed how and what kind of perfomance issues
> > are seen, please.
> > I expect IO based issues like WLAN package throughput or even lost
> > connections :)
>
> the bus doesn't get THAT slow.....
I expected wireless problems because 5 people with @atheros.com are in CC.
There is zero information about the problem itself and possibly affected 
devices/machines.
> in addition, most FSB systems have the memory controller in the chipset,
> next to the PCI logic... so that the FSB bus for DMA transactions only
> carries the snoop traffic, not the whole data.
So when should people look at this?

    Thomas
