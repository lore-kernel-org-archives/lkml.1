Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZCDMDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZCDMDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZCDMDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:03:09 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33460 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZCDMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:03:08 -0500
Message-ID: <49AE6DB9.3080403@s5r6.in-berlin.de>
Date: Wed, 04 Mar 2009 13:02:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Large amount of scsi-sgpool objects
References: <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de> <alpine.LFD.2.00.0903041004300.29264@localhost.localdomain> <20090304111235.GA14593@elte.hu> <49AE65EE.5020605@s5r6.in-berlin.de> <20090304114730.GA6736@elte.hu>
In-Reply-To: <20090304114730.GA6736@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Oh, so you use -tip?

As I wrote I work with people who use -rt.
That's the extent to which I personally "use" -tip and it's the sole
reason why I comment here.
-- 
Stefan Richter
-=====-==--= --== --=--
http://arcgraph.de/sr/
