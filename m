Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbXKAR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbXKAR3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXKAR3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:29:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXKAR3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:29:05 -0400
Date: Thu, 1 Nov 2007 10:28:56 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: vitalivanov@gmail.com
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au,
       zaitcev@redhat.com
Subject: Re: USB: FIx locks and urb->status in adutux
Message-Id: <20071101102856.4a597029.zaitcev@redhat.com>
In-Reply-To: <1193907984.17349.5.camel@dell1.softservecom.com>
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
	<1193907984.17349.5.camel@dell1.softservecom.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 11:06:24 +0200, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:

> > Do you still want to go ahead with a 2.4 backport?
> 
> Yep. Will do it asap. In latest 2.4 patch we had just a locks issue.
> So do you think I should modify 2.4 patch with all modifications we done in 2.6 version included?

Something like that, yes.

-- Pete
