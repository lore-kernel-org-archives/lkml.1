Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYD2GI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYD2GI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYD2GIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:08:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYD2GIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:08:19 -0400
Message-ID: <4816BA88.8050507@zytor.com>
Date: Mon, 28 Apr 2008 23:04:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "H. Peter Anvin" <hpa@kernel.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu>
In-Reply-To: <20080429050605.GA27875@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> And do we really consider that people's names in *comments* cannot
> be converted to pure ASCII ? I'm western european and have always
> been against accents in comments (another reason to write comments
> in english BTW). Unix and internet have lived without accents for
> almost 30 years without anyone really bothering. And now we try to
> put them everywhere (even in domain names, implying big security
> issues) and it causes real annoyances. People's names have not
> changed in 30 years, so I guess that the rules used during this
> time to ASCII-fy the names are still usable.
> 

For some languages, it's considered acceptable, for others it's 
considered major corruption.

	-hpa

