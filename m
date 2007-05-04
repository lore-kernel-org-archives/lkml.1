Return-Path: <linux-kernel-owner+w=401wt.eu-S1031437AbXEDRN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031437AbXEDRN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161024AbXEDRN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:13:28 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:61954 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031437AbXEDRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DRxLbbfGI3BuOX+OEVFSqwN5KMVZLe0X9Z4gfxZUVtJMJtHY/YiknOTX4SJecf/zLHHiGdm4EVrrhgUE5C0MMlj/PqsIW0uDHT7bMaCSX7h6AGZJAgyRg09+QTsJ+HYiaF+/ulYKb8ra0OfW58R/piC/eftQuDS8k9OxM9N5lD4=
Message-ID: <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
Date: Fri, 4 May 2007 19:13:25 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <463B7534.6000207@microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <200705041049.20989.oliver@neukum.org>
	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>
	 <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
	 <463B46F4.6090906@microgate.com> <463B4988.9090005@microgate.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> Antonino Ingargiola wrote:
> > The system blocks during booting. I can unblock it with SysReq+K but
> > then I'm unable to log into X.
>
> Hmmm, it tests here with no problem.
>
> Does reversing the patch and rebuilding the kernel fix the boot?

The kernel to which I applied the patch was vanilla 2.6.21.1, and it
is the one I'm currently running (no config changes or other patches).

Regards,

  ~ Antonio
