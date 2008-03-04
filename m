Return-Path: <linux-kernel-owner+w=401wt.eu-S1763910AbYCDP1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763910AbYCDP1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764854AbYCDP00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:26:26 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:51810 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764846AbYCDP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:26:25 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: -rc3 regression (was Re: 2.6.25-rc2 + smartd = hang ) 
In-reply-to: <20080304095701.DDF762DC027@tippex.mynet.homeunix.org> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080228143854.6350093C855@tippex.mynet.homeunix.org> <200803040116.42764.bzolnier@gmail.com> <200803040133.07736.bzolnier@gmail.com> <20080304095701.DDF762DC027@tippex.mynet.homeunix.org>
Comments: In-reply-to Anders Eriksson <aeriksson@fastmail.fm>
   message dated "Tue, 04 Mar 2008 10:57:01 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 04 Mar 2008 16:25:32 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080304152532.C06932DC027@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JWZ24-0002e4-8S.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JWZ24-0002e4-8S 1e0483ce07a6f643a64abe6053527481
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aeriksson@fastmail.fm said:
>> I need some sleep...  this patch is not going to help (though disabling
>> PREEMPT may be worth a try).  Sorry for the confusion.

> Ok, I'll drop the patch and, recompile without PREEMPT. 

Tested with PREEMPT_NONE. No change.

/A


