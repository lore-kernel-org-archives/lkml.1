Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbXLKQHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbXLKQHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXLKQHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:07:11 -0500
Received: from ts.adaptec.com ([162.62.93.58]:37706 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXLKQHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:07:10 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry indirectory) (fwd)
Date: Tue, 11 Dec 2007 11:07:08 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0101052133@otce2k301.adaptec.com>
In-Reply-To: <1197384034.19679.13.camel@n2o.xs4all.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry indirectory) (fwd)
Thread-Index: Acg8BwHqnFaU3M/mQdq45blwcGGziAACDE4w
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz> <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de> <20071130021226T.tomof@acm.org>  <20071130103450.GC7697@1und1.de> <1197384034.19679.13.camel@n2o.xs4all.nl>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Miquel van Smoorenburg" <miquels@cistron.nl>,
       "Anders Henke" <anders.henke@1und1.de>
Cc: "FUJITA Tomonori" <tomof@acm.org>, <matthew@wil.cx>, <jack@ucw.cz>,
       <fujita.tomonori@lab.ntt.co.jp>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miquel van Smoorenburg sez:
> I got the 64-bit dpt_i2o driver from Adaptec some time ago, and I have
> added 64-bit support to the 2.6.23.1 dpt_i2o driver based on that
> driver. I intended to submit it for 2.6.25 or so ... if I 
> have some time
> later today or tomorrow I'll try that next to see if that makes a
> difference.

Thanks, Mike, I will be watching your progress and offer my support! I
submitted a patch to move to 64 bit (which also drops the virt_to_bus
code) several years ago and it was rejected because of the focus on the
time to make i2o_block the driver of choice for this line of
controllers. I then reacted to the rejection by working with Markus
Lidel to move the 64 bit capabilities into the i2o driver.

Sincerely -- Mark Salyzyn
