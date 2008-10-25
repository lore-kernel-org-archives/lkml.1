Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYJYPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYJYPxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYJYPxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 11:53:04 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:54097 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYJYPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 11:53:03 -0400
Message-ID: <490340DD.9010605@skyrush.com>
Date: Sat, 25 Oct 2008 09:53:01 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] n-tty-output-bells-immediately
References: <48F2E450.1070508@skyrush.com>	<20081022103259.2d04729a@lxorguk.ukuu.org.uk>	<48FFD4F9.6090105@skyrush.com>	<20081024101029.6e826234@lxorguk.ukuu.org.uk>	<49033E1B.9030406@skyrush.com> <20081025164829.0b602e6e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081025164829.0b602e6e@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> BTW, where are the patches sitting at this point?  I saw an email about
>> "linux-next" that lists just the first of the 3 (the drop bkl one); and
>> your tty git is now empty.  Just curious.
> 
> Stephen asked that there was nothing being picked up for next that wasn't
> .28 material for the moment.

Oh, ok, so the echo/bkl-drop one is in .28, and the other 2 in .29?
Sounds good.  Do you just queue them yourself, or are they in some other
git now?

						-Joe

