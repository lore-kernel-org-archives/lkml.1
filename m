Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbYD1JRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbYD1JRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbYD1JRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:17:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60514
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757106AbYD1JRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:17:45 -0400
Date: Mon, 28 Apr 2008 02:17:45 -0700 (PDT)
Message-Id: <20080428.021745.17554887.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: mingo@elte.hu, James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428100154.0ac65cb6@core>
References: <20080427231809.GA13848@elte.hu>
	<20080427.163106.181887129.davem@davemloft.net>
	<20080428100154.0ac65cb6@core>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 28 Apr 2008 10:01:54 +0100

> > You can post whatever patches you like a million times to lkml.
> > That's not the problem.
> > 
> > It's that the patches don't get reviewed, posting them more or to a
> > different place doesn't help that.
> 
> So review them. Your comments strike me as the pot calling the kettle
> black given the way the network people like to live on their own mailing
> list.

Oh contraire.  Because we networking folks use a seperate mailing list
with a lower signal to noise ratio than lkml, and as a result more
specialization, more patches get more review by more specialists.

It's the point I'm trying to make every time the "post everything to
lkml" argument gets fronted.

Telling me to review all of this crud just ignores the problem.  And
the implication is that it's OK for unreviewed patches to go into the
tree, and it's most certainly not.

You might want to know that linux-next mainly exists because of how
much of this has been going on over the past half year or so.

