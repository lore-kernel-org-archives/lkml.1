Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbXKLTev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbXKLTev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXKLTel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:34:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbXKLTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:34:40 -0500
Message-ID: <4738AAA1.3080806@zytor.com>
Date: Mon, 12 Nov 2007 11:33:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [patch] x86: fix taking DNA during 64bit sigreturn
References: <20071111192758.GA21851@linux-os.sc.intel.com> <alpine.LFD.0.9999.0711121044130.30499@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711121044130.30499@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Anybody willing to try to do that unification around the 32-bit code?

Heck yes.  I'll grab this one.

	-hpa
