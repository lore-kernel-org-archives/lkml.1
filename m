Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYIHQc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYIHQc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYIHQcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:32:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYIHQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:32:50 -0400
Message-ID: <48C553A3.6000504@zytor.com>
Date: Mon, 08 Sep 2008 09:32:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So if it's behind EMBEDDED, and defaults to "on", then I have no problem 
> with changing the help text to say "If you do this, we'll statically do 
> things that really _require_ you to have a CPU that looks _exactly_ like 
> the CPU you claimed".
> 

Sounds like a plan.  I'll have a patch shortly.

	-hpa
