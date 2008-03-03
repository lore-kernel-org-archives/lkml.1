Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYCCVTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYCCVTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYCCVTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:19:16 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:42990 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYCCVTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:19:14 -0500
Date: Mon, 3 Mar 2008 22:17:52 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Adam Belay" <abelay@novell.com>,
       linux-pm@lists.linux-foundation.org,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303221752.5169f91d@mjolnir.drzeus.cx>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEA2E81B@orsmsx423.amr.corp.intel.com>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
	<20080303211842.6f492782@mjolnir.drzeus.cx>
	<20080303204603.GA19775@elf.ucw.cz>
	<20080303220310.0cab7213@mjolnir.drzeus.cx>
	<20080303210839.GJ13869@elf.ucw.cz>
	<924EFEDD5F540B4284297C4DC59F3DEEA2E81B@orsmsx423.amr.corp.intel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 13:14:28 -0800
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> I prefer leaving it off my default and enabling it on faulty hardware by
> some blacklist.
> 

But are these kind of shoddy components really trackable by model? I'd suspect it has more to do with the shipment of parts the day when the computer was manufactured.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
