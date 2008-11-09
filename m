Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYKIUet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYKIUet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYKIUel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:34:41 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:35417 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbYKIUek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:34:40 -0500
Date: Sun, 9 Nov 2008 21:34:32 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109203432.GB4361@ics.muni.cz>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl> <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081109122835.10f410fa@infradead.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 09 Nov 2008 21:34:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 12:28:35PM -0800, Arjan van de Ven wrote:
> for me, the plan is that we need to get Thomas' fixes tested by someone
> who can reproduce this very reliably. If they fix it, great.

as for me, 100% of boots require a key hit to proceed in 2.6.28-rc3 (more
precisely, the current git head).

-- 
Luká¹ Hejtmánek
