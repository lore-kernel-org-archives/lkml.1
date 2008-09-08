Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYIHSv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYIHSv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYIHSvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:51:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:38822 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbYIHSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:51:05 -0400
Date: Mon, 8 Sep 2008 11:51:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C55610.4020003@zytor.com>
Message-ID: <alpine.DEB.1.10.0809081150370.10413@asgard.lang.hm>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
 <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
 <alpine.DEB.1.10.0809080925400.10413@asgard.lang.hm> <48C55610.4020003@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, H. Peter Anvin wrote:

> david@lang.hm wrote:
>> I'd hate to see all the distros enabling embedded just to get this 
>> performance boost
>
> It's about producing code that works generically, not a performance boost.

I was arguing against the proposal to enable generic unless someone went 
under embedded to disable it.

if that's not what was being proposed, my apologies for misunderstanding.

David Lang
