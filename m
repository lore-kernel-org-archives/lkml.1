Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbXLLN1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbXLLN1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXLLN1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:27:42 -0500
Received: from ts.adaptec.com ([162.62.93.58]:49482 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbXLLN1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:27:41 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry indirectory) (fwd)
Date: Wed, 12 Dec 2007 08:25:10 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0101052210@otce2k301.adaptec.com>
In-Reply-To: <1197409983.6288.9.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry indirectory) (fwd)
Thread-Index: Acg8QI3zBRrFuZ7sT7KSs6cf95ES4gAgXnwg
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz> <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de> <20071130021226T.tomof@acm.org>  <20071130103450.GC7697@1und1.de> <1197384034.19679.13.camel@n2o.xs4all.nl> <1197409983.6288.9.camel@localhost.localdomain>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Miquel van Smoorenburg" <miquels@cistron.nl>,
       "Anders Henke" <anders.henke@1und1.de>
Cc: "FUJITA Tomonori" <tomof@acm.org>, <matthew@wil.cx>, <jack@ucw.cz>,
       <fujita.tomonori@lab.ntt.co.jp>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK, patch looks good. Thanks for composing this patch. Glad to hear of
successful test results.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Miquel 
> van Smoorenburg
. . .
> 
> I just recompiled 2.6.23.9 with the 64 bit patch for dpt_i2o 
> and now it
> boots just fine.
> 
> The patch is here:
> http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> 
> It's not the final version - it needs a few cleanups before it can be
> submitted, but perhaps you can test if it also works for you.
> 
> Mike.
