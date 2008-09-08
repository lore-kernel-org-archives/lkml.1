Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYIHR7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYIHR7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYIHR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:59:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYIHR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:59:26 -0400
Message-ID: <48C567ED.9010207@zytor.com>
Date: Mon, 08 Sep 2008 10:59:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org> <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org> <48C55C0A.7070203@zytor.com> <alpine.LFD.1.10.0809081028590.3117@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809081028590.3117@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> That is A TOTAL PIECE OF SH*T, and against gcc's own documentation.
> 
> "-mtune=x" is very much defined to be a performance _tuning_ option, not 
> an "architectural" option. 
> 
> Quite frankly, this is a gcc bug. Plain and simple. 
> 

No argument there.

	-hpa
