Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYD2JTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYD2JTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYD2JTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:19:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54362 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbYD2JTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:19:30 -0400
Date: Tue, 29 Apr 2008 11:19:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
In-Reply-To: <20080429100107.79ebf0cc@core>
Message-ID: <alpine.LNX.1.10.0804291119160.21466@fbirervta.pbzchgretzou.qr>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <20080429100107.79ebf0cc@core>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-04-29 11:01, Alan Cox wrote:
>> In fact, I would have better converted accentuated chars to their ASCII
>> equivalent to be more friendly with people who only read 7-bit.
>
>Perhaps we should put them in latin as well just in case any Roman is
>struggling with this new language 8) Distibutions have been shipping UTF
>enabled by default for years and years.

With some being overly late.
