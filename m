Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZERSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZERSzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZERSzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:55:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44263 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752468AbZERSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:55:31 -0400
Date: Mon, 18 May 2009 19:55:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Joe Perches <joe@perches.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to
 pr_notice(
Message-ID: <20090518195533.6ca4412d@lxorguk.ukuu.org.uk>
In-Reply-To: <m3skj2im12.fsf@intrepid.localdomain>
References: <cover.1242609803.git.joe@perches.com>
	<3ff9e9c7a8918f4d5f7bab5590f46073a196a4bf.1242609804.git.joe@perches.com>
	<4A11343C.5070809@ru.mvista.com>
	<m3skj2im12.fsf@intrepid.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Though I think most people would agree that the latter is much better,
> no?
> I think removal (rewording) of this rule has already been agreed upon,
> though not exactly yet codified.

There are no rules - its a style guide ;)

And yes sticking to 80 columns is frequently totally bogus especially
when it splits text strings

Alan
--
	"Policy is a poor man's substitute for common sense."
			-- David Woodhouse
