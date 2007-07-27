Return-Path: <linux-kernel-owner+w=401wt.eu-S936239AbXG0UET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936239AbXG0UET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXG0UEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:04:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:34862 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbXG0UEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cGsS3uvSBz4vf/6b9dOCdX1sgNjk6fl9VF9CIFT2Az+39GJtXR2lt5bdPryi1UneGmKZwLTN0O9j2EUdPtrIDThktqPq7Zo3fKFXtBXIdRsy/uiPLAvmwzy21nhqhocHCy8/UqbXz0MXeyxiZgkFzScRq9waE5XAsOroWbIO5FQ=
Message-ID: <19a3b7a80707271304g231860b8g690a32b12cac5835@mail.gmail.com>
Date: Fri, 27 Jul 2007 22:04:07 +0200
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: BUG: soft lockup detected on CPU#0!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0707271230s1f3f3c63w8ccdd8a0945e706a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19a3b7a80707251241t1cb5389ak8e5e3b27af2bde41@mail.gmail.com>
	 <6bffcb0e0707271230s1f3f3c63w8ccdd8a0945e706a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

2007/7/27, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>:
> Hi Christoph,
>
> On 25/07/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> > Hi,
> >
> > After burning a dvd I had to eject it and found that message in dmesg.
> > Syslog snippet and dmesg attached.
> > System is 2.6.21 (debian version), running a p4, issue reproducible.
>
> Does this happen on the latest -stable?
> http://eu.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2

I'm on holiday really soon - but will try when I'm back :)

> > Thanks for taking care of this,
> >
> > Christoph
> >
> >
>
> Regards,
> Michal

Christoph
