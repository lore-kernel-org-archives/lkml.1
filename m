Return-Path: <linux-kernel-owner+w=401wt.eu-S1765351AbYBMFXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765351AbYBMFXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYBMFXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:23:13 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:45235 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750941AbYBMFXM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:23:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oxuSOz9bzkp4lv74f6BtPHoA53JIRpp196sroVC3Xpo+fD9di9XpPNDVW+d2MQVFUQIPGAHrVJc0JZQdvTy/SmQJPWXBA2cnOD/y0e31Q5HBLD1CflT4Rw9BkO4XTl71zwZH1F5+LLELqBD001FUA8wo0SW4la7Amdlnntxj/t0=  ;
X-YMail-OSG: oa0EaVIVM1lxpuArq1CBBT6RK15AJ9RJWw8wo97sdieqO4ryCeD_lec1zVVJME88eUQvUxqx2w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: =?utf-8?q?Ra=C3=BAl_Porcel?= <armin76@gentoo.org>
Subject: Re: [ALPHA] ES40 fails to boot with >=kernel 2.6.23
Date: Wed, 13 Feb 2008 16:22:58 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru
References: <47B0858A.4090409@gentoo.org>
In-Reply-To: <47B0858A.4090409@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802131622.58778.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 04:27, Raúl Porcel wrote:
> Hi,
>
> We have a Compaq AlphaServer ES40 and since 2.6.23 it won't boot. I'm
> attaching the console log and the kernel config.
>
> Need to say that with a DEC Xp1000 it works fine, although they're
> different machines, of course.
> With .22 it boots fine, and by booting fine i mean after we reverted to
> 2.6.22 it booted again and everything worked as expected.
> Still hangs with latest kernel.
>
> I'm attaching the verlinux output as well, hope it helps. If i'm missing
> something, please don't hesitate to ask.
>
> Thanks

Hi,

Thanks for reporting. I'm not an alpha person, but I have
cc'ed them in case they missed this.
