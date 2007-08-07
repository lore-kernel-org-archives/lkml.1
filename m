Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXHGJPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXHGJPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbXHGJOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:14:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:17433 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409AbXHGJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QCOhZ96yGx6EmiQnz54UosSSkes1m+dlQwUV5Km940nX2droxCSifqWnW5ZzcNTfqX4VQ2FoaXh5gC6ADYxfBhsZd6VRl8JcjAMGioEST5M9QVuxf+exMbUm4z5Y3/cIDoEjo1uLfVWQW+QsfavQamZ4u9EAgtoPlaV9MVGekrE=
Message-ID: <52d486620708070214y4957e5b2ud34aa3252bf92c9@mail.gmail.com>
Date: Tue, 7 Aug 2007 12:14:53 +0300
From: "Amit Kucheria" <kucheria.amit@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [PATCH] USB: Only enable autosuspend by default on certain device classes
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Oliver Neukum" <oliver@neukum.org>, "Rogan Dawes" <lists@dawes.za.net>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070803125618.36ea1b2f.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>
	 <20070803112824.GA16802@srcf.ucam.org>
	 <200708031344.03282.oliver@neukum.org>
	 <20070803120418.GB16802@srcf.ucam.org> <46B31F03.80908@dawes.za.net>
	 <20070803123253.GA17725@srcf.ucam.org>
	 <20070803174435.GA17053@suse.de>
	 <20070803174810.GA23241@srcf.ucam.org> <46B38211.4030004@redhat.com>
	 <20070803125618.36ea1b2f.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07, Pete Zaitcev <zaitcev@redhat.com> wrote:

> I am wondering if Ubuntu has better user reporting, so if Matthew
> complains, it really means something.

https://bugs.launchpad.net/bugs/85488

Most of the current quirks list was assembled by Oliver from this thread IIRC.

/Amit

--
Amit Kucheria, Linux developer
