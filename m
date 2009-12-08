Return-Path: <linux-kernel-owner+w=401wt.eu-S935769AbZLHDPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935769AbZLHDPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934571AbZLHDPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:15:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412AbZLHDPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:15:32 -0500
Date: Tue, 8 Dec 2009 04:14:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
Message-ID: <20091208031442.GA17602@elte.hu>
References: <4B162A3C0200007800022F98@vpn.id2.novell.com>
 <4B1DB831.2030801@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DB831.2030801@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Ingo, Peter,
> 
> Could you pick his patch up?
> I confirmed that now it can be applied on Linus's tree and
> also tip:x86/urgent.

Sure. Can i add your signoff too?

	Ingo
