Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYICVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYICVh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYICVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:37:13 -0400
Received: from www.tglx.de ([62.245.132.106]:41352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYICVhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:12 -0400
Message-Id: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:36:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 0/6] final clockevents/hpet fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final version of the various clockevents fixes, which I will
send to Linus. Can you please give it a try on your machines, so we can
be sure that I did not mess up anything again.

Thanks for your patience and help

    tglx

-- 

