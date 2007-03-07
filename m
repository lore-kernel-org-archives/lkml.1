Return-Path: <linux-kernel-owner+w=401wt.eu-S965560AbXCGUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965560AbXCGUE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXCGUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:04:28 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:27821 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965516AbXCGUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GtbJcV1MJztQcafUBapoWJlAQx3tdTwPjLJXDB3qh45+r5ikC+jAcqQjBO+DHl5FpDbxkCcceFJBWyyVMbAeK+RlMWqM6lXDcXlTItREoFkeIE+OsvA3ibUEkZu2wt2Oj0ysuhb3I34GuU+dm/oiuEV1hjuHOfrmrXZynedHWkE=
Message-ID: <8bd0f97a0703071204j3d60476boeccd2c1d573ddedf@mail.gmail.com>
Date: Wed, 7 Mar 2007 15:04:26 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Cc: "Oleksiy Kebkal" <kebkal@gmail.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
In-Reply-To: <m3649durx1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	 <m3bqj6jebt.fsf@maximus.localdomain>
	 <200703061824.08834.rgetz@blackfin.uclinux.org>
	 <57354eff0703070454u24e97309j55ec9de584ced71e@mail.gmail.com>
	 <m3649durx1.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Oleksiy Kebkal" <kebkal@gmail.com> writes:
> > May be it would be good idea to develop some tty control driver which
> > provides a
> > possibility to change default setting of the drivers?
>
> If there is a real need for it (such as a real existing device)...
> then sure (it wouldn't be a "default setting" anymore, of course).

if there wasnt a real need to control this behavior (as in existing
devices), then i wouldnt have spawned this thread in the first place
:)

i dont muck around in serial core for fun
-mike
