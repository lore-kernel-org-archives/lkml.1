Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbXFDKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbXFDKri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXFDKrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:47:32 -0400
Received: from snowcat.de ([89.31.32.98]:2686 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbXFDKrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:47:31 -0400
X-Greylist: delayed 1701 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 06:47:31 EDT
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: stallion driver dmesg notice
Organization: Disorganized
From: Ingo Korb <usenet@mail.snowcat.de>
In-Reply-To: <21118142571565213847@wsc.cz> (Jiri Slaby's message of "Mon,  4
 Jun 2007 10:44:17 +0200 (CEST)")
References: <46633BC8.3838.43FB8257@ml.akana.de> <304615082222625376@wsc.cz>
	<304615082222625376@wsc.cz> <21118142571565213847@wsc.cz>
Date: Mon, 04 Jun 2007 12:19:05 +0200
Message-ID: <uvee458fa.fsf@dragon.akana.de>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:21:070604:linux-kernel@vger.kernel.org::NKGRYbY1b/TT0F3x:000000000
	00000000000000000000000069Wx
X-Hashcash: 1:21:070604:jirislaby@gmail.com::w5ess/liW58h3GRT:000000000000000000
	0000000000000000000000004tXx
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Okay, tty alloc after pci init, attached patch should fix it. Could you
> retest?

Loads find and seems to work with basic tests (and no character loss,
yay!). I'll try 8-link bonded ppp when I've set up a second box.

-ik

