Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbXGGEKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbXGGEKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 00:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXGGEKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 00:10:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXGGEKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 00:10:34 -0400
Message-ID: <468F11FE.2070404@zytor.com>
Date: Fri, 06 Jul 2007 21:09:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux@horizon.com, davidel@xmailserver.org, linux-kernel@vger.kernel.org
Subject: Re: A simpler variant on sys_indirect?
References: <20070630205235.6638.qmail@science.horizon.com> <alpine.LFD.0.98.0706301447530.1172@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706301447530.1172@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The batching has serious problems, not the least of which is that it's a 
> fundamentally more complex interface, and introduces issues like "how do 
> we pass values from one system call to the next". 
> 

Why, we obviously need a Turing-complete language running in kernel 
space (interpreted, of course, to keep it secure.)  Pretty soon we can 
run the whole app in it, and we'll have to have a JIT to make it suck on 
less.  Since it's going to need caffeine, we can call it "Java."

	-hpa

