Return-Path: <linux-kernel-owner+w=401wt.eu-S934960AbZLHDpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960AbZLHDpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZLHDpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:45:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZLHDpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:45:51 -0500
Message-ID: <4B1DCBB4.6010805@zytor.com>
Date: Mon, 07 Dec 2009 19:44:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
References: <4B162A3C0200007800022F98@vpn.id2.novell.com> <4B1DB831.2030801@jp.fujitsu.com> <20091208031442.GA17602@elte.hu>
In-Reply-To: <20091208031442.GA17602@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 07:14 PM, Ingo Molnar wrote:
> 
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> Ingo, Peter,
>>
>> Could you pick his patch up?
>> I confirmed that now it can be applied on Linus's tree and
>> also tip:x86/urgent.
> 
> Sure. Can i add your signoff too?
> 

Oops... for some reason I thought it already had been applied.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

