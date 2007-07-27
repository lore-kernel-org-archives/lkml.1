Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbXG0Tas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbXG0Tas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761430AbXG0Tal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:30:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39106 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760978AbXG0Tal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XAIA7iz1wvjyO8AZJ8cIN46KJi1swaHYvRGcwQhJbSGyixLUU0ewl9vZxbr1Z8qJXyHqOc5teUL6TkgqEet+VQFU5Gb/1cShEYDzITTsfWQOYgIyjdKV/oLAaHeB3mCc9V6bE67wPpyFt4Ui4/Hr5B8lAd2Dp69QBuPrFM4Ht24=
Message-ID: <6bffcb0e0707271230s1f3f3c63w8ccdd8a0945e706a@mail.gmail.com>
Date: Fri, 27 Jul 2007 21:30:34 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: BUG: soft lockup detected on CPU#0!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <19a3b7a80707251241t1cb5389ak8e5e3b27af2bde41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19a3b7a80707251241t1cb5389ak8e5e3b27af2bde41@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 25/07/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> Hi,
>
> After burning a dvd I had to eject it and found that message in dmesg.
> Syslog snippet and dmesg attached.
> System is 2.6.21 (debian version), running a p4, issue reproducible.

Does this happen on the latest -stable?
http://eu.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2

>
> Thanks for taking care of this,
>
> Christoph
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
