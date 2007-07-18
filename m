Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbXGRXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbXGRXSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXGRXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:18:44 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:42559 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXGRXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:18:43 -0400
To: James.Bottomley@SteelEye.com
Cc: tomof@acm.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1184768624.3464.15.camel@localhost.localdomain>
References: <20070718092130V.tomof@acm.org>
	<1184766854.3464.4.camel@localhost.localdomain>
	<1184768624.3464.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070719081821U.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 19 Jul 2007 08:18:21 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 09:23:44 -0500

> On Wed, 2007-07-18 at 08:54 -0500, James Bottomley wrote:
> > You're welcome ... although there's still a problem for modular builds.
> > This is what my /sys/class/bsg looks like:
> 
> Sorry, lets see if I can get the paste to work this time:
> 
> jejb@hobholes> ls /sys/class/bsg/
> 0:0:1:0/  sdb/

Surely, confusing. Let's dump the if and use the sdev name for now.

Thanks,
