Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbXJZJ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbXJZJ5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbXJZJ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:57:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:45846 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbXJZJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kA/zfDvEQZGdnz46GU41NfMjZff69Pa7evXARwjT5OyzF+BEZoDSOzv1XS13zDH9s/cErS/eWdgIH+4EbHchTtmygebBTTxxNrxl0Rmpt1+rxtGLTUgtvBcGhuomyp5Cv3MCKKNBf8hYU0AzzUm+h0zN+3IoMBKVbic2A+8MTAA=
Message-ID: <35fbaa3e0710260257s36467cb6o1fc900e11e0bf06a@mail.gmail.com>
Date: Fri, 26 Oct 2007 12:57:06 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: USB: FIx locks and urb->status in adutux
Cc: "Oliver Neukum" <oliver@neukum.org>, "Pete Zaitcev" <zaitcev@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netwiz@crc.id.au
In-Reply-To: <20071024212535.GA4638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	 <200710231138.38266.oliver@neukum.org>
	 <20071023185302.5ce9d187.zaitcev@redhat.com>
	 <200710241649.13257.oliver@neukum.org>
	 <20071024212535.GA4638@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On 10/25/07, Greg KH <greg@kroah.com> wrote:
> Hm, I think I'll wait for Pete and you to agree and send me a final
> version before applying anything here :)

I'm testing the final patch Pete created with all the notes.
Will let you know if there are issues with it. If not it can be
applied to your tree.

Thanks,
Vitaliy
