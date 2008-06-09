Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYFIVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYFIVEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYFIVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:04:45 -0400
Received: from mail.suse.de ([195.135.220.2]:56399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYFIVEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:04:44 -0400
Date: Mon, 9 Jun 2008 23:04:41 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amul Shah <amul.shah@unisys.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, anderson@redhat.com,
       "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609230441.77d3dc8a@kopernikus.site>
In-Reply-To: <20080609210055.GK3542@redhat.com>
References: <87bq2bmvro.fsf@saeurebad.de>
	<20080609132207.GC3542@redhat.com>
	<20080609182341.00d6e746@halley.suse.de>
	<484D5CCB.5020709@firstfloor.org>
	<1213041041.19111.68.camel@ustr-shaha1-linux-dev.na.uis.unisys.com>
	<20080609221732.1e14e5d5@kopernikus.site>
	<20080609202935.GI3542@redhat.com>
	<20080609224211.2ef0f74c@kopernikus.site>
	<20080609205429.GJ3542@redhat.com>
	<20080609225734.2bb9ee64@kopernikus.site>
	<20080609210055.GK3542@redhat.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2008-06-09 17:00]:
> 
> I am really not sure. :-). In the past, Andrew picked up the patches, kept
> in his tree for couple of days and if something is important, he will push
> it out to Linus.

Ok, I'm a bit confused about linux-next, and the new x86 tree from
Ingo/Thomas and how to merge patches. So, I'll wait a few days and then
resend the patches with Andrew in Cc.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Maintenance
