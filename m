Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYLLNDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYLLNDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbYLLNDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:03:03 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:64753 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbYLLNDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:03:03 -0500
To: adobriyan@gmail.com
Cc: rydberg@bitmath.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mjg@redhat.com, nicolas@boichat.ch,
       rydberg@euromail.se, linux-kernel@vger.kernel.org,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [patch 18/19] Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.oand applesmc.o
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812092114.mB9LETsI027215@imap1.linux-foundation.org>
	<493F1C96.5070400@bitmath.org>
	<200812120305.mBC35vh8078366@www262.sakura.ne.jp>
	<20081212042503.GA14668@x200.localdomain>
In-Reply-To: <20081212042503.GA14668@x200.localdomain>
Message-Id: <200812122202.CBJ65627.JOLQVtOFFSFMHO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 12 Dec 2008 22:02:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> > -MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
> > +MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);
> 
> I sent patch which does "#define dmi_device_id dmi_system_id" and thus
> avoids yet another wrapper.
> 
I see. I'll try your patch after it is merged (2.6.28-rc8-gitX or 2.6.28-rc9 ?).

Thanks.
