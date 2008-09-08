Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYIHPv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYIHPv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYIHPvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:51:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYIHPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:51:20 -0400
Message-ID: <48C549D6.10002@zytor.com>
Date: Mon, 08 Sep 2008 08:50:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <20080908155021.GN26079@one.firstfloor.org>
In-Reply-To: <20080908155021.GN26079@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The help text is indeed out of date.  I did a patch yesterday to, among 
>> other things, update it; I also want to verify that we are disabling all 
>> options that can cause gcc or binutils to generate nopl's; I plan to 
>> push it today.
> 
> You (or whoever did those changes) likely broke a lot of distribution setups 
> subtly then. Hopefully the changes were worth that.

Likely broke a lot of distribution setups how?

	-hpa
