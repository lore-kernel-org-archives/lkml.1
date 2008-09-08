Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYIHQn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYIHQn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYIHQns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:43:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYIHQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:43:48 -0400
Message-ID: <48C55610.4020003@zytor.com>
Date: Mon, 08 Sep 2008 09:42:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: david@lang.hm
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809080925400.10413@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0809080925400.10413@asgard.lang.hm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> I'd hate to see all the distros enabling 
> embedded just to get this performance boost

It's about producing code that works generically, not a performance boost.

	-hpa
