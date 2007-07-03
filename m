Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbXGCFSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbXGCFSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXGCFR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:17:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:9167 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXGCFR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p0QPILCKMMgdzjGeG1T2PkYuIqEwCLmf7UGhYGQb+RNqNsEoDJQ6XAMJPJ0RFx6u4w+U90qm4iXa+6YEzwYdaMV+oXs8BrTWyp9zygJrjap4freda0yi70fjaF0eWBrKRSFT3an0/NOSxpOvJCTzNJmmfrsqVzYrNC5WEx3GEms=
Message-ID: <86802c440707022217w40d67b40o9f533a1f93b4807f@mail.gmail.com>
Date: Mon, 2 Jul 2007 22:17:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
Cc: linux-usb-devel@lists.sourceforge.net, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703051336.GF18420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
	 <200707021537.13840.yinghai.lu@sun.com>
	 <20070703051336.GF18420@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 02, 2007 at 03:37:13PM -0700, Yinghai Lu wrote:
> > [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
>
> Um, your subject doesn't match the patch below.  You might want to
> verify it again...
>

it should be

[PATCH 4/4] usb: add usb_alloc_urb_node to use use kmalloc_node

YH
