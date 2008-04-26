Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYDZL2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYDZL2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYDZL2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:28:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYDZL2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:28:08 -0400
Date: Sat, 26 Apr 2008 13:34:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080426113405.GC17905@one.firstfloor.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151747.GA3265@one.firstfloor.org> <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com> <20080426095938.GB17905@one.firstfloor.org> <48130F00.5010408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48130F00.5010408@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is anybody working on that? I would volunteer to do it.

Feel free to take it.

-Andi
