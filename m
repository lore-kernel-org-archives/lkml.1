Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbXELRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbXELRLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXELRLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 13:11:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405AbXELRLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 13:11:10 -0400
Date: Sat, 12 May 2007 10:03:21 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, David Woodhouse <dwmw2@infradead.org>,
       Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Andrew Morton <akpm@osdl.org>, zaitcev@redhat.com
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-Id: <20070512100321.c54f3dbe.zaitcev@redhat.com>
In-Reply-To: <20070507222311.4589fc8a@the-village.bc.nu>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
	<20070507222311.4589fc8a@the-village.bc.nu>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 22:23:11 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> We had this discussion before. Kernel sources should use utf-8 for
> comments where neccessary. Many names cannot be correctly represented in
> US ascii, and mangling them is just plain rude.

I have to disagree here. It is using the native alphabet for the name
which is very rude, because non-native hackers cannot read it. This is
true on systems which can display the name correctly, which may come
as a surprise to you. I used to receive e-mails from Mr. मयंक जैन at work.
Do you know who the heck he is? I sure didn't. Beautiful gliphs though!

One peculiar thing I have observed is how all this "UTF-8 in names"
nonsense is being pushed by western Europeans. Why? That's because
their umlauts are grandfathered in, and because English speakers _can_
read their names approximately, simply by ignoring all the strokes
above the letter (or, in Norwegians and Polaks cases, going through
the letter). So do not try to pretend that "correctness" has anything
to do with your demands. Nowhere the ethnocentrism comes through clearer
than in demanding that everyone in the world were able to read names
spelled as convenient for you and not for them.

-- Pete
