Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbXKAJGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbXKAJGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXKAJGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:06:32 -0400
Received: from mail.softservecom.com ([195.160.232.17]:56697 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXKAJGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:06:31 -0400
Subject: Re: USB: FIx locks and urb->status in adutux
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>, vitalivanov@gmail.com
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au
In-Reply-To: <20071031150107.206892a4.zaitcev@redhat.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	 <200710231138.38266.oliver@neukum.org>
	 <20071023185302.5ce9d187.zaitcev@redhat.com>
	 <1193234987.13750.21.camel@dell1.softservecom.com>
	 <20071024202555.4f1cd215.zaitcev@redhat.com>
	 <1193681097.20985.31.camel@dell1.softservecom.com>
	 <20071029212433.c9837c4b.zaitcev@redhat.com>
	 <1193749794.27085.15.camel@dell1.softservecom.com>
	 <20071030145421.f1f0aa53.zaitcev@redhat.com>
	 <1193831694.2226.35.camel@dell1.softservecom.com>
	 <20071031150107.206892a4.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1193907984.17349.5.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Thu, 01 Nov 2007 11:06:24 +0200
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2007 09:06:24.0475 (UTC) FILETIME=[7A55E2B0:01C81C66]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 00:01, Pete Zaitcev wrote:

> Sorry about that. I'll try to be more explicit in the future.

OK, got it. Thanks.

> > I just tried the latest patch and all seems to be good.
> > BTW, slab corruption issue that I saw on the original driver we started fixing on is not an issue any more.
> 
> Very well, I'll post this for Greg anew today.

Great, tnx.

> Do you still want to go ahead with a 2.4 backport?

Yep. Will do it asap. In latest 2.4 patch we had just a locks issue.
So do you think I should modify 2.4 patch with all modifications we done in 2.6 version included?

Vitaliy

