Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYIJG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYIJG3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYIJG3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:29:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYIJG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:29:10 -0400
Date: Wed, 10 Sep 2008 08:28:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86_64: signal: clean up signal_fault()
Message-ID: <20080910062857.GB14700@elte.hu>
References: <48C7126A.5010304@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C7126A.5010304@ct.jp.nec.com>
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


applied these patches to x86/signal:

 764e8d1: x86: signal_64.c: make handle_signal() similar
 0c40ed7: x86: signal_64.c: arg for restore_i387_xstate() is void __user *
 b2994ef: x86: signal_64.c: clean up signal_fault()

thanks!

	Ingo
