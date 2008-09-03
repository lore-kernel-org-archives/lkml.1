Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYICXAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYICXAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYICXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:00:20 -0400
Received: from inhex.net ([193.33.178.145]:49101 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYICXAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:00:19 -0400
Date: Thu, 4 Sep 2008 02:00:03 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: [patch 0/6] final clockevents/hpet fixes
Message-ID: <20080903230003.GA1958@laptop.local>
References: <20080903212735.713411776@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903212735.713411776@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:36:25PM -0000, Thomas Gleixner wrote:
> This is the final version of the various clockevents fixes, which I will
> send to Linus. Can you please give it a try on your machines, so we can
> be sure that I did not mess up anything again.
> 

Applied full patchset on top of 2.6.27-rc5. Works great on my affected system.

Tested-by: Dmitry Nezhevenko <dion@inhex.net>
 
-- 
WBR, Dmitry
