Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbXKHWrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbXKHWrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbXKHWrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:47:32 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:37214 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXKHWrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bW9wZv2gLVxus25Am9fZy1ue29cxun6EVldgu7xTZLSlC8+NgyXFPnbIHOeFVtr9lrV/Ai9jQZb2JfATiJmM/AwKTecK5ptD8w7iFIPpYrkK1TL7mQ+6V7dli2ZRDv5rPXn4Z4YXPyd9irxXm1tdKpVXkpeIrDL4byQ5cVh3Ab4=
Message-ID: <13426df10711081447o688550a4jc01be2d7f06209e0@mail.gmail.com>
Date: Thu, 8 Nov 2007 14:47:30 -0800
From: "ron minnich" <rminnich@gmail.com>
To: "Anthony Liguori" <anthony@codemonkey.ws>
Subject: Re: [Lguest] [PATCH] virtio config_ops refactoring
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Anthony Liguori" <aliguori@us.ibm.com>,
       virtualization@lists.linux-foundation.org, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47338EA0.6050100@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4730A8F3.6020008@us.ibm.com>
	 <200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au>
	 <4732774C.6020903@codemonkey.ws>
	 <200711090924.28659.rusty@rustcorp.com.au>
	 <47338EA0.6050100@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm sorry, I've been stuck on other things (NFS RDMA anyone?) and
missed part of this discussion.

Is it really the case that operations on virtio devices will involve
outl/inl etc.?

Apologies in advance for my failure to pay attention.

thanks

ron
