Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbXGDGMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbXGDGMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXGDGMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:12:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38123 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbXGDGMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jaPsMK3hgs2MSPZn4biyrGqmkxR0nynLLI4gR6BHHf4hbQeQwAP0tb6X+mE2G2R/2afH/9ufjjWEiF6ipK9eqZXAO+5YC933kBsPesrbCEzXf/BPRxavXMqcNPlEvOhIJNTw2LWZhN2JSuLayx6+7Px/x3Z5wgVVcpvfIf9Uyzs=
Message-ID: <86802c440707032312j5b7851dbo826d679fc0e160b1@mail.gmail.com>
Date: Tue, 3 Jul 2007 23:12:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
Cc: linux-usb-devel@lists.sourceforge.net, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703055915.GA19086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
	 <200707021537.13840.yinghai.lu@sun.com>
	 <20070703051336.GF18420@kroah.com>
	 <86802c440707022217w40d67b40o9f533a1f93b4807f@mail.gmail.com>
	 <20070703055915.GA19086@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 02, 2007 at 10:17:56PM -0700, Yinghai Lu wrote:
> >  [PATCH 4/4] usb: add usb_alloc_urb_node to use use kmalloc_node
>
> On the linux-usb-devel list we are discussing how usb_alloc_urb is being
> reworked to look totally different, so this change will conflict with
> that.
>
Good.

YH
