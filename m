Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZKGVJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZKGVJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZKGVJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:09:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:46848 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZKGVJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:09:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
Date: Sat, 7 Nov 2009 22:10:00 +0100
User-Agent: KMail/1.9.10
Cc: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       mcgrof@gmail.com, Matthew Garrett <mjg@redhat.com>,
       "Arjan van de Ven\"" <arjan@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Amod Bodas <Amod.Bodas@atheros.com>,
       David Quan <David.Quan@atheros.com>,
       Kishore Jotwani <Kishore.Jotwani@atheros.com>
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> <200911072152.57596.trenn@suse.de>
In-Reply-To: <200911072152.57596.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911072210.01619.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009 09:52:56 pm Thomas Renninger wrote:
> On Friday 06 November 2009 09:01:00 pm Luis R. Rodriguez wrote:
> > With cpu frequency scaling you may run into some system
> > performance issues when the FSB changes speed due to the
> > throughput constraints this brings on the system.
>
> Interesting.
> Could you be a bit more detailed how and what kind of perfomance issues are
> seen, please.
> I expect IO based issues like WLAN package throughput or even lost
> connections :) "wireless" is also a good word to grep for...
> If this gets documented also a bit more info about the HW should get
> added. The problem sounds rather restricted to specific models (atom based,
> laptop, desktop chipsets?)?
Or whatabout adding a list of affected machine/chipset models. The ordinary
user will hardly find his IO throughput problem in:
Documentation/cpu-freq/user-guide.txt
Then a lot of people will be happy when starting to google for their HW.

     Thomas
