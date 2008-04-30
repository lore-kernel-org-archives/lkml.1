Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbYD3MeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbYD3MeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbYD3Mdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:33:50 -0400
Received: from www.tglx.de ([62.245.132.106]:40523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288AbYD3Mdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:33:49 -0400
Date: Wed, 30 Apr 2008 14:32:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
In-Reply-To: <1209557398-8228-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
Message-ID: <alpine.LFD.1.10.0804301432080.6003@apollo.tec.linutronix.de>
References: <1209557398-8228-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1505641265-1209558780=:6003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1505641265-1209558780=:6003
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 30 Apr 2008, Uwe Kleine-König wrote:
> From: Thomas Gleixner <tglx@linutronix.de>

I have the fixed version already queued for linus since yesterday :)

Thanks,
	tlgx
--8323328-1505641265-1209558780=:6003--
