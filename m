Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYBQU2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYBQU2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYBQU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:28:05 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:60334 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYBQU2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:28:04 -0500
Date: Sun, 17 Feb 2008 21:26:42 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, aneesh.kumar@in.ibm.com, efault@gmx.de
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080217202642.GA4327@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz> <20080214165551.GA21963@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080214165551.GA21963@linux.vnet.ibm.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 17 Feb 2008 21:26:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:25:51PM +0530, Srivatsa Vaddagiri wrote:
> The patch is against 2.6.25-rc1. I would request you to check for
> difference it makes with CONFIG_FAIR_GROUP_SCHED and
> CONFIG_FAIR_USER_SCHED turned on.

well, I tried the patch against 2.6.25-rc2-git1. It seems to be better but
without CONFIG_FAIR_GROUP_SCHED it is still even better.

-- 
Luká¹ Hejtmánek
