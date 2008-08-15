Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYHOCnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYHOCnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHOCnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:43:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41532 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYHOCnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:43:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu>
	<86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
	<m1ljyzcqg4.fsf@frodo.ebiederm.org>
	<86802c440808141342k6cb0dc59ud067018b0a171232@mail.gmail.com>
	<86802c440808141424u3284f862gcd81e3cc585ddac4@mail.gmail.com>
	<m1zlnf87d8.fsf@frodo.ebiederm.org>
	<86802c440808141749l626d59e6h888b802343916df3@mail.gmail.com>
	<m1bpzv851l.fsf@frodo.ebiederm.org>
	<86802c440808141841t3ab7e745pc5266dcfaa64d1aa@mail.gmail.com>
Date: Thu, 14 Aug 2008 19:33:55 -0700
In-Reply-To: <86802c440808141841t3ab7e745pc5266dcfaa64d1aa@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 14 Aug 2008 18:41:55 -0700")
Message-ID: <m1ljyz6m7g.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0043]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> yes, done. now it is same as 64 bit.

Cool.  I'm now off until monday.  Hopefully I can post some patches and we can
have a good debate then.

Eric
