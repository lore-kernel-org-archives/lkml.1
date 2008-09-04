Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYIDSdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYIDSdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYIDSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:33:30 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:52680 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYIDSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:33:29 -0400
Date: Thu, 4 Sep 2008 15:33:37 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Dmitry Nezhevenko <dion@inhex.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch 0/6] final clockevents/hpet fixes
Message-ID: <20080904153337.68a39607@doriath.conectiva>
In-Reply-To: <20080903230003.GA1958@laptop.local>
References: <20080903212735.713411776@linutronix.de>
	<20080903230003.GA1958@laptop.local>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 4 Sep 2008 02:00:03 +0300
Dmitry Nezhevenko <dion@inhex.net> escreveu:

| On Wed, Sep 03, 2008 at 09:36:25PM -0000, Thomas Gleixner wrote:
| > This is the final version of the various clockevents fixes, which I will
| > send to Linus. Can you please give it a try on your machines, so we can
| > be sure that I did not mess up anything again.
| > 
| 
| Applied full patchset on top of 2.6.27-rc5. Works great on my affected system.

 Worked for me too, sorry for the delay I was testing this on more
machines.

-- 
Luiz Fernando N. Capitulino
