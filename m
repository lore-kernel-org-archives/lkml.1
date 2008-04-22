Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbYDVAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbYDVAUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbYDVAUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:20:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758756AbYDVAUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:20:35 -0400
Date: Mon, 21 Apr 2008 17:20:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [GIT]: Sparc
In-Reply-To: <20080421.170640.181023820.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0804211720170.2779@woody.linux-foundation.org>
References: <20080421.153231.108090227.davem@davemloft.net> <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org> <20080421.170640.181023820.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Apr 2008, David Miller wrote:
> 
> There is no capability loss, the code we have hasn't worked on
> anything other than extremely trivial Solaris cases, and that's
> when it was working.

Ahh, ok. Will pull.

		Linus
