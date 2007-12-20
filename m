Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbXLTVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbXLTVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXLTVvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:51:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55770
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbXLTVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:51:34 -0500
Date: Thu, 20 Dec 2007 13:51:33 -0800 (PST)
Message-Id: <20071220.135133.262055434.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: apw@shadowen.org, joe@perches.com, lizf@cn.fujitsu.com,
       akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071220210741.6dc3caf5@the-village.bc.nu>
References: <1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 20 Dec 2007 21:07:41 +0000

> The kernel printk messages are sentences. English language sentences end
> with a full stop. They are messages printed up for normal human beings to
> read and they should therefore be properly written.

I totally agree.

I think the incorrect grammar and lack of proper capitalization and
puntuation in the kernel messages and our changelog entries is totally
embarassing for a professional software project.

And I'm not talking about cases where someone is not a native speaker
and just needs some help to get it right.  I'm talking about people
who are native speakers and nearly encourage phrase quality and style
that borders on teenager "innanet speak" in what we publish to the
entire world.

Some people just can't be bothered to hold down the shift key when
typing in the first letter of a word from time to time, I guess.
Laziness is the only reasonable explanation I can come up with.

And it's totally ironic (and moronic) because some of these same folks
are the ones who get all over people for whitespace and tabbing in
the code.
