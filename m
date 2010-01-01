Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122Ab0AAQLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0AAQLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994Ab0AAQLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:11:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43760 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0AAQLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:11:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5848"; a="31205940"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <20100101151818.GI3944@atrey.karlin.mff.cuni.cz>
References: <20091227093537.GD11737@elf.ucw.cz>
	 <20091227201514.GA29174@elf.ucw.cz>
	 <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
	 <20091227203704.GK11737@elf.ucw.cz> <20091227211322.GB29174@elf.ucw.cz>
	 <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
	 <20091227101824.GB1478@ucw.cz>
	 <a55d774e0912281224y7360dfdbu8a251743026bdd28@mail.gmail.com>
	 <20091228204848.GB1637@ucw.cz> <1262049913.17445.27.camel@desktop>
	 <20100101151818.GI3944@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jan 2010 08:08:48 -0800
Message-ID: <1262362128.2159.4.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-01 at 16:18 +0100, Pavel Machek wrote:

> > I have it in my tree already .. My tree has some duplication over
> > staging, for instance the rpc code is mostly in my tree, as is the smd
> > code.
> 
> Do you expect you can just merge those for 2.6.34? That would be
> great.

I will try ..

One major thing I will not merge is the qdsp stuff .. So it's
good that it's in staging.. With that I also wanted to mention that
there is an alsa driver that (I think) uses the qdsp code.. I was
thinking that the parts of the qdsp code that the alsa driver uses we
could pull out and add into the alsa driver. Then clean up the alsa
driver..

Daniel


