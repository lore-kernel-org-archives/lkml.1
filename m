Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYLBQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYLBQ3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLBQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:29:46 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:60277 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYLBQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:29:45 -0500
Message-ID: <49356274.6080400@diamondcut.com.br>
Date: Tue, 02 Dec 2008 14:29:40 -0200
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: About git-bisect (was: Linux 2.6.28-rc7)
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Just do
> 
> 	git bisect start
> 	git bisect bad v2.6.27
> 	git bisect good v2.6.28-rc6-00007-ged31348
> 
> and off you go. That would help enormously.

Hi Linus, is possible plan something to make faster and easier the way
to loking for a specific bug?

E.g:
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>

In this bug, I think that it appear after ~2.6.22, so is necessary do a
git-bisect more than 13 times!

I need more than 20min to compile each kernel, so is necessary ~260min.

My wife will kill me if I says: Hey baby, wait 260min to me compile a
lot of kernel here.

Best regards,
Renato
