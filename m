Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXB1VkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXB1VkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXB1VkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:40:15 -0500
Received: from p02c11o141.mxlogic.net ([208.65.145.64]:59570 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXB1VkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:40:12 -0500
Date: Wed, 28 Feb 2007 23:40:29 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070228214029.GB4357@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220152.GA29575@stusta.de> <20070228211318.GB4301@mellanox.co.il> <1172698026.11473.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172698026.11473.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 28 Feb 2007 21:42:29.0131 (UTC) FILETIME=[58288DB0:01C75B81]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15026.001
X-TM-AS-Result: No--11.496200-4.000000-2
X-Spam: [F=0.4993609249; S=0.499(2007010901)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Quoting Thomas Gleixner <tglx@linutronix.de>:
>Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
>
>On Wed, 2007-02-28 at 23:13 +0200, Michael S. Tsirkin wrote:
>> >Subject    : ThinkPad T60: no screen after suspend to RAM
>> >References : http://lkml.org/lkml/2007/2/22/391
>> >Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
>> >Handled-By : Ingo Molnar <mingo@elte.hu>
>> >Status     : unknown
>> 
>> Just reproduced this in -rc2.
>> Another thing I noticed:
>> with 2.6.20, pressing Fn/F4 generates an ACPI event and triggers suspend to RAM.
>> 
>> On 2.6.21-rc2, after resume (when the box is accessible from network),
>> pressing Fn/F4 again does not seem to have any effect.
>
>Can you please get the dmesg output after resume via the network ?

The link above has it.

-- 
MST
