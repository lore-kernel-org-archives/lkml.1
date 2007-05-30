Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbXE3SNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbXE3SNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXE3SNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:13:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53369 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXE3SNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:13:05 -0400
Message-ID: <465DBEBD.7000205@cs.helsinki.fi>
Date: Wed, 30 May 2007 21:13:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Tero Roponen <teanropo@jyu.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: tty-related oops in latest kernel(s)?
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi> <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com> <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com> <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi> <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com> <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi> <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com> <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi> <20070530083953.9909bcef.akpm@linux-foundation.org> <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
In-Reply-To: <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tero Roponen wrote:
> after some trial and error I found a simple way to trigger the
> corruption:

Nice. This triggers on the file corruption on 2.6.21.3 also?
