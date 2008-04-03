Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbYDCBQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbYDCBQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYDCBQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:16:32 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:61958 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYDCBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D+/wCQpOSn+SV91yx49jGxj0tJnFodzVPlv3UmVe2C3eMyLz8vvfg1Y4W0ubT+GelcV20vjaD+9h4jSN+e4Zvb227ZcCLHV+nu3mpwKneuEo3d4CIOuV1tPTdMn/ukbFI9BbZUfIcWl/g3VwwxuHEjH+UzIqgASIgDczlMMSxhI=
Message-ID: <dd18b0c30804021816k3c8a37ew2a47b3b2331648d5@mail.gmail.com>
Date: Thu, 3 Apr 2008 01:16:30 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: suspend
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <47F42C5F.6090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>
	 <200804021419.06672.rjw@sisk.pl>
	 <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>
	 <200804021939.46733.rjw@sisk.pl>
	 <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
	 <47F42259.8030603@gmail.com>
	 <dd18b0c30804021744m67fe4db4m8aed3897945baaa8@mail.gmail.com>
	 <47F42C5F.6090003@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
Yes both the drives are working(put a dvd in after a wakeup and it
worked.) As for the wireless if I  dont shutdown the wireless  before
a suspend, and leave it as is, it seems to be still connected after
the wakeup(that's pretty cool)

regards;
                Justin P. Mattock


On Thu, Apr 3, 2008 at 1:01 AM, Tejun Heo <htejun@gmail.com> wrote:
> Justin Mattock wrote:
>
> > Hello; attached is kern.log as asked and lspci -nn.
> >
>
>  kernel log is missing.
>
>
> > I've noticed some avc's in there. makes me wonder if this is why
> > wpa_supplicant isnt working after a wakeup
> >
>
>  Probably not.  It just took one extra try to wake the device up.  Both hard
> and optical drives are accessible after resume, right?
>
>  --
>  tejun
>



-- 
Justin P. Mattock
