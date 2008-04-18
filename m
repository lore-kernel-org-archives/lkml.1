Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYDRQiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYDRQiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYDRQhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:37:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63783 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYDRQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HcQqTGNLCfPNdbaTe64UN9sBFIuupin3R3mcPaHUTYM7AU0iryU0mUbylnM4iQVuVaT+v9tFm4MiTi7QTMeAygbcREKLjvzG6By1O//liXDFhzhKhg3iHIcLJFx45FlOjC8ujIFcdBHuvYFocmGkjhN143u926uNA7aCVzSSgJQ=
Message-ID: <e9c3a7c20804180937o56684497tb6a6277b17bd06a0@mail.gmail.com>
Date: Fri, 18 Apr 2008 09:37:46 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH mm] sysfs: add /sys/dev/usb to handle CONFIG_USB_DEVICE_CLASS=y
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <1208505291.2514.9.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
	 <20080418032146.GA8754@kroah.com>
	 <e9c3a7c20804172159x16554078i6d5c9097eeadc91c@mail.gmail.com>
	 <1208505291.2514.9.camel@lov.site>
X-Google-Sender-Auth: 69e1b277f39d7a03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 12:54 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>  We will find a solution. :)
>
>  The following should work for the common case.
>

Thanks!  This resolves the warnings here.  Now I'll take a shot at
fixing the CONFIG_BLOCK=n case.

>  Best,
>  Kay
>

Regards,
Dan
