Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbXGCBhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbXGCBhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 21:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXGCBhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 21:37:25 -0400
Received: from cogent.ecohler.net ([69.183.62.137]:55119 "EHLO
	cogent.ecohler.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbXGCBhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 21:37:24 -0400
X-Greylist: delayed 3007 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 21:37:24 EDT
X-DKIM: Sendmail DKIM Filter v1.0.0 mail.prv.sapience.com l630lGfP027032
From: Mail List <lists@sapience.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suspend2 is getting a new name.
Date: Mon, 2 Jul 2007 20:47:15 -0400
User-Agent: KMail/1.9.7
References: <200707021730.57066.nigel@nigel.suspend2.net> <9e0cf0bf0707021141g1c71318dje2e7bf2709e66594@mail.gmail.com> <b637ec0b0707021211jcf26634n384c1733ddf34864@mail.gmail.com>
In-Reply-To: <b637ec0b0707021211jcf26634n384c1733ddf34864@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707022047.15953.lists@sapience.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On Monday 02 July 2007 03:11:52 pm Fabio Comolli wrote:
> > > Am I the only person on this list thinking that a plain "hibernate"
> > > will be a much better choice?
> >
> > No you are not the only one :)

  I like the frozen name - but similar to you, if the name suspendX and 
hibernate are confusing in not distinguishing ram from disk perhaps one could 
do something obvious like:
     
        hibernate_2_ram
        hibernate_2_disk

 or something shorter ... perhaps involving Ice and twist ?? ;-)

gene/
