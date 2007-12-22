Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXLVOJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXLVOJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 09:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLVOJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 09:09:40 -0500
Received: from main.gmane.org ([80.91.229.2]:45031 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXLVOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 09:09:39 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: Trailing periods in kernel messages
Date: Sat, 22 Dec 2007 15:04:16 +0100
Message-ID: <m33atu25cv.fsf@ursa.amorsen.dk>
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr> <20071221114103.GA801@gondor.apana.org.au> <Pine.LNX.4.64.0712211254160.21721@fbirervta.pbzchgretzou.qr> <20071221160125.GJ2310@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:OmMV/YxOYMFzEnkmSquQnEz+UI4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> On Fri, Dec 21, 2007 at 12:55:16PM +0100, Jan Engelhardt wrote:
>> o_O  I better continue believing it is the subject. Because with
>> one extra word at the front, you can make this a "complete sentence":
>> 
>> 	Please initialize [the] current offset in xfs_file_readdir.
>
> That still looks like an incomplete sentence, although orders are often
> given in that form.  Something like these seem more like complete
> sentences:

It's simply the imperative. You can make perfectly good English
sentences in just one word -- "Eat." is an example. See more at
http://en.wikipedia.org/wiki/Imperative_mood.

It is a bit of a mystery why the kernel is ordering me to initialize
the current offset of xfs_file_readdir though. I don't know how to do
that, so I guess it's lucky that I don't use XFS. Who knows what would
happen if I didn't correctly initialize xfs_file_readdir.


/Benny


