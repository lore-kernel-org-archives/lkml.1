Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbYHRHMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbYHRHMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYHRHLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:11:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYHRHLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:11:54 -0400
Date: Mon, 18 Aug 2008 09:11:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Chandru Siddalingappa <chandru@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86,calgary: fix section mismatch warning -
	get_tce_space_from_tar
Message-ID: <20080818071133.GA17961@elte.hu>
References: <1218988252-17932-1-git-send-email-marcin.slusarz@gmail.com> <1218988252-17932-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218988252-17932-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied these commits to tip/x86/urgent:

f710666: x86, calgary: fix section mismatch warning - get_tce_space_from_tar
d19fbfd: x86: silence section mismatch warning - get_local_pda
c6a92a2: x86, percpu: silence section mismatch warnings related to EARLY_PER_CPU

thanks Marcin!

	Ingo
