Return-Path: <linux-kernel-owner+w=401wt.eu-S967683AbXEHDYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967683AbXEHDYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXEHDYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:24:19 -0400
Received: from haxent.com ([65.99.219.155]:2610 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbXEHDYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:24:19 -0400
Message-ID: <463FED5B.9060400@haxent.com.br>
Date: Tue, 08 May 2007 00:24:11 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br>	 <463BC3CA.6050109@haxent.com.br>	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>	 <463CFA37.3020809@haxent.com.br>	 <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>	 <463F9B68.305@haxent.com.br>	 <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>	 <463FB327.4070906@haxent.com.br> <a36005b50705071932s6880d732hf228612ad8416bca@mail.gmail.com>
In-Reply-To: <a36005b50705071932s6880d732hf228612ad8416bca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/7/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> Anyway, we could extend epoll to be mmapable...
> 
> Welcome to kevent, well, except with a lot more ballast and awkward interfaces.

So an mmapable epoll is equivalent to kevent.. great! Well, expect
without a whole new giant bloated monolithic interface.

And this thread was about something else... :-)

--
Davi Arnaut
