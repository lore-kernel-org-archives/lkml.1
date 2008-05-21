Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbYEUMTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbYEUMTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761864AbYEUMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:18:52 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:19665 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761633AbYEUMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:18:51 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1211372328!8508732!3
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 21 May 2008 14:09:06 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <lethal@linux-sh.org>, <gregkh@suse.de>, <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080521120906.GA27413@digi.com>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520210713.GE3220@local> <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com> <20080521064938.GA11580@digi.com> <aec7e5c30805210109p664fd917r32f8dc6aa1c4c746@mail.gmail.com> <20080521092533.GB29607@digi.com> <aec7e5c30805210350l41b537c3n70cfef2e10b54548@mail.gmail.com> <20080521110416.GA10407@digi.com> <aec7e5c30805210456r6f09b1a4sfef5bcefc82f5ba6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30805210456r6f09b1a4sfef5bcefc82f5ba6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 May 2008 12:09:06.0760 (UTC) FILETIME=[77CF5480:01C8BB3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> Would you like to fold in the irq_handler and irq_enable function in
> your patch, or would you like me to make a patch that fits on top of
> your latest version?
I would prefer the latter, because my patch already has acks and is
complete as such.  Moreover your suggestion needs the irq_enable patch.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
