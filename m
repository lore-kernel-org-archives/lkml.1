Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbZLHDeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbZLHDeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934925AbZLHDeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:34:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37014 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934690AbZLHDeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:34:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B1DC921.9090203@jp.fujitsu.com>
Date: Tue, 08 Dec 2009 12:33:53 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
References: <4B162A3C0200007800022F98@vpn.id2.novell.com> <4B1DB831.2030801@jp.fujitsu.com> <20091208031442.GA17602@elte.hu>
In-Reply-To: <20091208031442.GA17602@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> Ingo, Peter,
>>
>> Could you pick his patch up?
>> I confirmed that now it can be applied on Linus's tree and
>> also tip:x86/urgent.
> 
> Sure. Can i add your signoff too?

Of course yes.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

